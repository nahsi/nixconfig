#!/usr/bin/env python3
"""Aggregate a primary-versus-baseline benchmark workspace.

Input layout:
    <workspace>/eval-<id>/eval_metadata.json
    <workspace>/eval-<id>/{primary,baseline}/run-<n>/
        outputs/
        grading.json
        timing.json
"""

from __future__ import annotations

import argparse
import json
import math
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROLES = ("primary", "baseline")
RUN_PATTERN = re.compile(r"run-([1-9][0-9]*)$")
EVAL_PATTERN = re.compile(r"eval-([0-9]+)$")


class BenchmarkInputError(ValueError):
    """The workspace does not meet the benchmark input contract."""


def load_json(path: Path, description: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise BenchmarkInputError(f"missing {description}: {path}") from error
    except (json.JSONDecodeError, OSError) as error:
        raise BenchmarkInputError(f"invalid {description}: {path}: {error}") from error
    if not isinstance(value, dict):
        raise BenchmarkInputError(f"invalid {description}: {path} must contain an object")
    return value


def finite_number(value: Any, field: str, path: Path) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not math.isfinite(value):
        raise BenchmarkInputError(f"invalid {field} in {path}: expected a finite number")
    return float(value)


def nonnegative_integer(value: Any, field: str, path: Path) -> int:
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        raise BenchmarkInputError(f"invalid {field} in {path}: expected a non-negative integer")
    return value


def validate_metadata(path: Path, expected_eval_id: int) -> dict[str, Any]:
    metadata = load_json(path, "eval_metadata.json")
    eval_id = metadata.get("eval_id")
    if isinstance(eval_id, bool) or not isinstance(eval_id, int) or eval_id != expected_eval_id:
        raise BenchmarkInputError(f"invalid eval_id in {path}: expected {expected_eval_id}")
    if not isinstance(metadata.get("eval_name"), str) or not metadata["eval_name"].strip():
        raise BenchmarkInputError(f"invalid eval_name in {path}: expected a non-empty string")
    if not isinstance(metadata.get("prompt"), str):
        raise BenchmarkInputError(f"invalid prompt in {path}: expected a string")
    if not isinstance(metadata.get("assertions"), list):
        raise BenchmarkInputError(f"invalid assertions in {path}: expected a list")
    return metadata


def validate_grading(path: Path) -> dict[str, Any]:
    grading = load_json(path, "grading.json")
    summary = grading.get("summary")
    if not isinstance(summary, dict):
        raise BenchmarkInputError(f"invalid grading.json: {path} has no summary object")
    passed = nonnegative_integer(summary.get("passed"), "summary.passed", path)
    failed = nonnegative_integer(summary.get("failed"), "summary.failed", path)
    total = nonnegative_integer(summary.get("total"), "summary.total", path)
    pass_rate = finite_number(summary.get("pass_rate"), "summary.pass_rate", path)
    if total == 0 or passed + failed != total:
        raise BenchmarkInputError(f"invalid grading.json: {path} has inconsistent summary totals")
    if not math.isclose(pass_rate, passed / total, rel_tol=0.0, abs_tol=0.005):
        raise BenchmarkInputError(f"invalid grading.json: {path} pass_rate does not match summary totals")
    expectations = grading.get("expectations", [])
    if not isinstance(expectations, list):
        raise BenchmarkInputError(f"invalid expectations in {path}: expected a list")
    for index, expectation in enumerate(expectations):
        if not isinstance(expectation, dict):
            raise BenchmarkInputError(f"invalid expectations[{index}] in {path}: expected an object")
        if not isinstance(expectation.get("text"), str) or not expectation["text"].strip():
            raise BenchmarkInputError(f"invalid expectations[{index}].text in {path}")
        if not isinstance(expectation.get("passed"), bool):
            raise BenchmarkInputError(f"invalid expectations[{index}].passed in {path}")
        if not isinstance(expectation.get("evidence"), str) or not expectation["evidence"].strip():
            raise BenchmarkInputError(f"invalid expectations[{index}].evidence in {path}")
    execution_metrics = grading.get("execution_metrics", {})
    if not isinstance(execution_metrics, dict):
        raise BenchmarkInputError(f"invalid execution_metrics in {path}: expected an object")
    return {
        "pass_rate": pass_rate,
        "passed": passed,
        "failed": failed,
        "total": total,
        "expectations": expectations,
        "notes": grading.get("user_notes_summary", {}),
        "execution_metrics": execution_metrics,
    }


def validate_timing(path: Path) -> dict[str, float | int]:
    timing = load_json(path, "timing.json")
    tokens = nonnegative_integer(timing.get("total_tokens"), "total_tokens", path)
    duration_ms = finite_number(timing.get("duration_ms"), "duration_ms", path)
    if duration_ms < 0:
        raise BenchmarkInputError(f"invalid duration_ms in {path}: value cannot be negative")
    return {"tokens": tokens, "duration_ms": duration_ms, "time_seconds": duration_ms / 1000}


def load_notes(path: Path | None) -> list[str]:
    if path is None:
        return []
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise BenchmarkInputError(f"missing analyzer notes: {path}") from error
    except (json.JSONDecodeError, OSError) as error:
        raise BenchmarkInputError(f"invalid analyzer notes: {path}: {error}") from error
    if not isinstance(value, list) or any(
        not isinstance(note, str) or not note.strip()
        for note in value
    ):
        raise BenchmarkInputError(f"invalid analyzer notes: {path} must contain non-empty strings")
    return value


def role_runs(eval_dir: Path, role: str) -> dict[int, Path]:
    role_dir = eval_dir / role
    if not role_dir.is_dir():
        raise BenchmarkInputError(f"missing {role} directory: {role_dir}")
    runs: dict[int, Path] = {}
    for entry in sorted(role_dir.iterdir()):
        if not entry.is_dir():
            raise BenchmarkInputError(f"invalid run entry: {entry}")
        match = RUN_PATTERN.fullmatch(entry.name)
        if not match:
            raise BenchmarkInputError(f"invalid run directory: {entry}")
        run_number = int(match.group(1))
        runs[run_number] = entry
    if not runs:
        raise BenchmarkInputError(f"no runs found for {role}: {role_dir}")
    return runs


def load_run(eval_id: int, eval_name: str, role: str, run_number: int, run_dir: Path) -> dict[str, Any]:
    outputs = run_dir / "outputs"
    if not outputs.is_dir():
        raise BenchmarkInputError(f"missing outputs directory: {outputs}")
    grading = validate_grading(run_dir / "grading.json")
    timing = validate_timing(run_dir / "timing.json")
    metrics = grading["execution_metrics"]
    tool_calls = nonnegative_integer(
        metrics.get("total_tool_calls", 0),
        "execution_metrics.total_tool_calls",
        run_dir / "grading.json",
    )
    errors = nonnegative_integer(
        metrics.get("errors_encountered", 0),
        "execution_metrics.errors_encountered",
        run_dir / "grading.json",
    )
    notes_source = grading["notes"]
    notes: list[str] = []
    if isinstance(notes_source, dict):
        for key in ("uncertainties", "needs_review", "workarounds"):
            values = notes_source.get(key, [])
            if isinstance(values, list):
                notes.extend(str(value) for value in values)
    return {
        "eval_id": eval_id,
        "eval_name": eval_name,
        "configuration": role,
        "run_number": run_number,
        "result": {
            "pass_rate": grading["pass_rate"],
            "passed": grading["passed"],
            "failed": grading["failed"],
            "total": grading["total"],
            "time_seconds": timing["time_seconds"],
            "tokens": timing["tokens"],
            "tool_calls": tool_calls,
            "errors": errors,
        },
        "expectations": grading["expectations"],
        "notes": notes,
    }


def load_run_results(workspace: Path) -> dict[str, list[dict[str, Any]]]:
    eval_dirs = sorted((entry for entry in workspace.iterdir() if entry.is_dir() and EVAL_PATTERN.fullmatch(entry.name)), key=lambda entry: int(EVAL_PATTERN.fullmatch(entry.name).group(1)))
    if not eval_dirs:
        raise BenchmarkInputError(f"no eval-N directories found in {workspace}")

    results = {role: [] for role in ROLES}
    expected_run_numbers: set[int] | None = None
    for eval_dir in eval_dirs:
        eval_id = int(EVAL_PATTERN.fullmatch(eval_dir.name).group(1))
        unexpected = [
            entry.name
            for entry in eval_dir.iterdir()
            if entry.name not in {"eval_metadata.json", *ROLES}
        ]
        if unexpected:
            raise BenchmarkInputError(f"unexpected eval input in {eval_dir}: {', '.join(sorted(unexpected))}")
        metadata = validate_metadata(eval_dir / "eval_metadata.json", eval_id)
        primary_runs = role_runs(eval_dir, "primary")
        baseline_runs = role_runs(eval_dir, "baseline")
        run_numbers = set(primary_runs)
        if run_numbers != set(baseline_runs):
            raise BenchmarkInputError(f"primary and baseline run sets differ in {eval_dir}")
        if expected_run_numbers is None:
            expected_run_numbers = run_numbers
        elif run_numbers != expected_run_numbers:
            raise BenchmarkInputError(f"run sets differ between eval directories: {eval_dir}")
        for role, runs in (("primary", primary_runs), ("baseline", baseline_runs)):
            for run_number, run_dir in runs.items():
                results[role].append(load_run(eval_id, metadata["eval_name"], role, run_number, run_dir))
    return results


def calculate_stats(values: list[float]) -> dict[str, float]:
    if not values:
        raise ValueError("statistics require at least one value")
    mean = sum(values) / len(values)
    variance = sum((value - mean) ** 2 for value in values) / (len(values) - 1) if len(values) > 1 else 0.0
    return {
        "mean": round(mean, 4),
        "stddev": round(math.sqrt(variance), 4),
        "min": round(min(values), 4),
        "max": round(max(values), 4),
    }


def aggregate_results(results: dict[str, list[dict[str, Any]]]) -> dict[str, Any]:
    summary: dict[str, Any] = {}
    for role in ROLES:
        runs = results.get(role, [])
        if not runs:
            raise BenchmarkInputError(f"no {role} run results")
        summary[role] = {
            "pass_rate": calculate_stats([run["result"]["pass_rate"] for run in runs]),
            "time_seconds": calculate_stats([run["result"]["time_seconds"] for run in runs]),
            "tokens": calculate_stats([float(run["result"]["tokens"]) for run in runs]),
        }
    summary["delta"] = {
        metric: round(summary["primary"][metric]["mean"] - summary["baseline"][metric]["mean"], 4)
        for metric in ("pass_rate", "time_seconds", "tokens")
    }
    return summary


def generate_benchmark(
    workspace: Path,
    skill_name: str = "",
    skill_path: str = "",
    notes: list[str] | None = None,
) -> dict[str, Any]:
    results = load_run_results(workspace)
    runs = [run for role in ROLES for run in results[role]]
    eval_ids = sorted({run["eval_id"] for run in runs})
    return {
        "schema_version": 2,
        "comparison": {
            "primary": "primary",
            "baseline": "baseline",
            "delta": "primary_minus_baseline",
        },
        "metadata": {
            "skill_name": skill_name or "<skill-name>",
            "skill_path": skill_path or "<path/to/skill>",
            "executor_model": "<model-name>",
            "analyzer_model": "<model-name>",
            "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "evals_run": eval_ids,
            "runs_per_configuration": len(results["primary"]) // len(eval_ids),
        },
        "runs": runs,
        "run_summary": aggregate_results(results),
        "notes": list(notes or ()),
    }


def format_delta(value: float, precision: int) -> str:
    return f"{value:+.{precision}f}"


def generate_markdown(benchmark: dict[str, Any]) -> str:
    metadata = benchmark["metadata"]
    comparison = benchmark["comparison"]
    summary = benchmark["run_summary"]
    primary_name = comparison["primary"]
    baseline_name = comparison["baseline"]
    primary = summary[primary_name]
    baseline = summary[baseline_name]
    delta = summary["delta"]
    lines = [
        f"# Skill Benchmark: {metadata['skill_name']}",
        "",
        f"**Model**: {metadata['executor_model']}",
        f"**Date**: {metadata['timestamp']}",
        f"**Evals**: {', '.join(map(str, metadata['evals_run']))} ({metadata['runs_per_configuration']} matched runs each)",
        "",
        "## Summary",
        "",
        "| Metric | Primary | Baseline | Primary minus baseline |",
        "|--------|---------|----------|------------------------|",
        f"| Pass Rate | {primary['pass_rate']['mean'] * 100:.0f}% ± {primary['pass_rate']['stddev'] * 100:.0f}% | {baseline['pass_rate']['mean'] * 100:.0f}% ± {baseline['pass_rate']['stddev'] * 100:.0f}% | {format_delta(delta['pass_rate'], 2)} |",
        f"| Time | {primary['time_seconds']['mean']:.1f}s ± {primary['time_seconds']['stddev']:.1f}s | {baseline['time_seconds']['mean']:.1f}s ± {baseline['time_seconds']['stddev']:.1f}s | {format_delta(delta['time_seconds'], 1)}s |",
        f"| Tokens | {primary['tokens']['mean']:.0f} ± {primary['tokens']['stddev']:.0f} | {baseline['tokens']['mean']:.0f} ± {baseline['tokens']['stddev']:.0f} | {format_delta(delta['tokens'], 0)} |",
    ]
    if benchmark.get("notes"):
        lines.extend(["", "## Notes", ""])
        lines.extend(f"- {note}" for note in benchmark["notes"])
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Aggregate a primary-versus-baseline benchmark workspace")
    parser.add_argument("benchmark_dir", type=Path)
    parser.add_argument("--skill-name", default="")
    parser.add_argument("--skill-path", default="")
    parser.add_argument("--notes", type=Path, help="Analyzer notes JSON array")
    parser.add_argument("--output", "-o", type=Path)
    args = parser.parse_args()

    if not args.benchmark_dir.is_dir():
        print(f"directory not found: {args.benchmark_dir}", file=sys.stderr)
        return 1
    try:
        notes = load_notes(args.notes)
        benchmark = generate_benchmark(args.benchmark_dir, args.skill_name, args.skill_path, notes)
        markdown = generate_markdown(benchmark)
    except BenchmarkInputError as error:
        print(error, file=sys.stderr)
        return 1

    output_json = args.output or args.benchmark_dir / "benchmark.json"
    output_md = output_json.with_suffix(".md")
    output_json.write_text(json.dumps(benchmark, indent=2) + "\n", encoding="utf-8")
    output_md.write_text(markdown + "\n", encoding="utf-8")
    print(f"Generated: {output_json}")
    print(f"Generated: {output_md}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
