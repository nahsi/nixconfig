from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "aggregate_benchmark.py"
SPEC = importlib.util.spec_from_file_location("aggregate_benchmark", SCRIPT)
aggregate_benchmark = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
sys.modules[SPEC.name] = aggregate_benchmark
SPEC.loader.exec_module(aggregate_benchmark)


class AggregateBenchmarkTests(unittest.TestCase):
    def make_workspace(self, root: Path, primary_rate: float = 1.0, baseline_rate: float = 0.0) -> Path:
        workspace = root / "iteration-1"
        eval_dir = workspace / "eval-1"
        eval_dir.mkdir(parents=True)
        (eval_dir / "eval_metadata.json").write_text(
            json.dumps({"eval_id": 1, "eval_name": "Documented layout", "prompt": "Do work", "assertions": []}),
            encoding="utf-8",
        )
        for role, rate in (("primary", primary_rate), ("baseline", baseline_rate)):
            run = eval_dir / role / "run-1"
            (run / "outputs").mkdir(parents=True)
            passed = int(rate)
            (run / "grading.json").write_text(
                json.dumps({"expectations": [], "summary": {"passed": passed, "failed": 1 - passed, "total": 1, "pass_rate": rate}}),
                encoding="utf-8",
            )
            (run / "timing.json").write_text(
                json.dumps({"total_tokens": 10, "duration_ms": 100}),
                encoding="utf-8",
            )
        return workspace

    def test_documented_layout_primary_minus_baseline(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            benchmark = aggregate_benchmark.generate_benchmark(self.make_workspace(Path(temporary)))

            self.assertEqual(2, benchmark["schema_version"])
            self.assertEqual({"primary": "primary", "baseline": "baseline", "delta": "primary_minus_baseline"}, benchmark["comparison"])
            self.assertEqual(["primary", "baseline"], [run["configuration"] for run in benchmark["runs"]])
            self.assertEqual(1.0, benchmark["run_summary"]["delta"]["pass_rate"])
            self.assertIn("Primary minus baseline", aggregate_benchmark.generate_markdown(benchmark))

    def test_derives_seconds_and_loads_analyzer_notes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workspace = self.make_workspace(Path(temporary))
            timing = workspace / "eval-1" / "primary" / "run-1" / "timing.json"
            timing.write_text(
                json.dumps({"total_tokens": 10, "duration_ms": 2500}),
                encoding="utf-8",
            )
            notes_path = workspace / "analysis.json"
            notes_path.write_text(json.dumps(["Primary is more accurate."]), encoding="utf-8")

            benchmark = aggregate_benchmark.generate_benchmark(
                workspace,
                notes=aggregate_benchmark.load_notes(notes_path),
            )

            self.assertEqual(2.5, benchmark["runs"][0]["result"]["time_seconds"])
            self.assertEqual(["Primary is more accurate."], benchmark["notes"])

    def test_empty_and_malformed_workspaces_fail_without_output(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            empty = root / "empty"
            empty.mkdir()
            result = subprocess.run([sys.executable, str(SCRIPT), str(empty)], capture_output=True, text=True, check=False)
            self.assertNotEqual(0, result.returncode)
            self.assertFalse((empty / "benchmark.json").exists())

            malformed = self.make_workspace(root / "malformed")
            grading = malformed / "eval-1" / "baseline" / "run-1" / "grading.json"
            grading.write_text("{", encoding="utf-8")
            result = subprocess.run([sys.executable, str(SCRIPT), str(malformed)], capture_output=True, text=True, check=False)
            self.assertNotEqual(0, result.returncode)
            self.assertFalse((malformed / "benchmark.json").exists())


if __name__ == "__main__":
    unittest.main()
