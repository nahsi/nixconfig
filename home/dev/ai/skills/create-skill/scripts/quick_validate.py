#!/usr/bin/env python3
"""Validate a skill package and its concrete skill URI dependencies."""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
from typing import Iterable
from urllib.parse import unquote


ALLOWED_PROPERTIES = frozenset({
    "name",
    "description",
    "license",
    "allowed-tools",
    "metadata",
    "compatibility",
    "globs",
    "alwaysApply",
    "hide",
    "disable-model-invocation",
    "disableModelInvocation",
})
NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
URI_START = "skill://"


@dataclass(frozen=True)
class Issue:
    path: Path
    line: int
    message: str


@dataclass(frozen=True)
class SkillPackage:
    root: Path
    name: str


def issue(path: Path, line: int, message: str) -> Issue:
    return Issue(path, line, message)


def parse_frontmatter(path: Path) -> tuple[dict[str, str], list[Issue]]:
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as error:
        return {}, [issue(path, 1, f"cannot read file: {error}")]

    if not lines or lines[0] != "---":
        return {}, [issue(path, 1, "no YAML frontmatter found")]

    try:
        end = lines.index("---", 1)
    except ValueError:
        return {}, [issue(path, 1, "invalid frontmatter format")]

    frontmatter: dict[str, str] = {}
    issues: list[Issue] = []
    current_key: str | None = None
    for line_number, line in enumerate(lines[1:end], start=2):
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if line[0].isspace() or line.startswith("-"):
            if current_key is None:
                issues.append(issue(path, line_number, "invalid frontmatter entry"))
            continue
        match = re.fullmatch(r"([A-Za-z][A-Za-z0-9-]*):(?:[ \t]*(.*))?", line)
        if not match:
            issues.append(issue(path, line_number, "invalid frontmatter entry"))
            continue
        key, value = match.groups()
        current_key = key
        if key in frontmatter:
            issues.append(issue(path, line_number, f"duplicate frontmatter key: {key}"))
            continue
        frontmatter[key] = value or ""
    return frontmatter, issues


def unquote_scalar(value: str) -> str | None:
    value = value.strip()
    if not value:
        return ""
    if value[0] in {"'", '"'}:
        if len(value) < 2 or value[-1] != value[0]:
            return None
        return value[1:-1]
    if (
        value[0] in "[{"
        or value.lower() in {"true", "false", "null", "~"}
        or re.fullmatch(r"[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)", value)
    ):
        return None
    return value


def validate_frontmatter(package: SkillPackage) -> list[Issue]:
    skill_md = package.root / "SKILL.md"
    if not skill_md.is_file():
        return [issue(skill_md, 1, "SKILL.md not found")]

    frontmatter, issues = parse_frontmatter(skill_md)
    for key in sorted(set(frontmatter) - ALLOWED_PROPERTIES):
        issues.append(issue(skill_md, 1, f"unexpected key in SKILL.md frontmatter: {key}"))

    for required in ("name", "description"):
        if required not in frontmatter:
            issues.append(issue(skill_md, 1, f"missing '{required}' in frontmatter"))

    name = unquote_scalar(frontmatter.get("name", ""))
    if name is None:
        issues.append(issue(skill_md, 1, "name must be a string"))
    elif not name:
        issues.append(issue(skill_md, 1, "name cannot be empty"))
    else:
        if not NAME_PATTERN.fullmatch(name):
            issues.append(issue(skill_md, 1, f"name '{name}' should be kebab-case"))
        if len(name) > 64:
            issues.append(issue(skill_md, 1, "name is too long; maximum is 64 characters"))

    description = unquote_scalar(frontmatter.get("description", ""))
    if description is None:
        issues.append(issue(skill_md, 1, "description must be a string"))
    elif not description:
        issues.append(issue(skill_md, 1, "description cannot be empty"))
    elif "<" in description or ">" in description:
        issues.append(issue(skill_md, 1, "description cannot contain angle brackets"))
    elif len(description) > 1024:
        issues.append(issue(skill_md, 1, "description is too long; maximum is 1024 characters"))

    compatibility = unquote_scalar(frontmatter.get("compatibility", ""))
    if compatibility is None:
        issues.append(issue(skill_md, 1, "compatibility must be a string"))
    elif len(compatibility) > 500:
        issues.append(issue(skill_md, 1, "compatibility is too long; maximum is 500 characters"))
    return issues


def catalog_packages(target: SkillPackage, roots: Iterable[Path]) -> dict[str, Path]:
    catalogs = {target.name: target.root}
    for root in roots:
        root = root.resolve()
        if (root / "SKILL.md").is_file():
            candidates = [root]
        elif root.is_dir():
            candidates = [entry for entry in root.iterdir() if entry.is_dir()]
        else:
            continue
        for candidate in candidates:
            skill_md = candidate / "SKILL.md"
            if not skill_md.is_file():
                continue
            frontmatter, _ = parse_frontmatter(skill_md)
            name = unquote_scalar(frontmatter.get("name", ""))
            if name and NAME_PATTERN.fullmatch(name):
                catalogs.setdefault(name, candidate.resolve())
    return catalogs


def uri_token(line: str, start: int) -> str:
    end = start
    while end < len(line) and line[end] not in " \t\r\n`<>'\"()[]{}":
        end += 1
    return line[start:end].rstrip(".,;:!?")

def validate_uri(token: str, source: Path, line: int, catalogs: dict[str, Path]) -> list[Issue]:
    if token == URI_START or token.startswith("skill://<"):
        return []
    body = token[len(URI_START):]
    body, fragment_separator, fragment = body.partition("#")
    if "?" in body or (fragment_separator and not fragment):
        return [issue(source, line, f"malformed skill URI: {token}")]
    owner, separator, encoded_path = body.partition("/")
    if not owner or not NAME_PATTERN.fullmatch(owner):
        return [issue(source, line, f"malformed skill URI: {token}")]
    owner_root = catalogs.get(owner)
    if owner_root is None:
        return [issue(source, line, f"skill URI owner not found: {owner}")]
    if not separator:
        resource = Path("SKILL.md")
    else:
        decoded_path = unquote(encoded_path)
        pure_path = PurePosixPath(decoded_path)
        if (
            not decoded_path
            or pure_path.is_absolute()
            or any(part in {"", ".", ".."} for part in pure_path.parts)
        ):
            return [issue(source, line, f"malformed or escaping skill URI: {token}")]
        resource = Path(*pure_path.parts)

    candidate = owner_root / resource
    if candidate.is_file():
        return []
    return [issue(source, line, f"skill URI resource not found: {token}")]


def validate_resources(package: SkillPackage, roots: Iterable[Path]) -> list[Issue]:
    catalogs = catalog_packages(package, roots)
    issues: list[Issue] = []
    for markdown in sorted(package.root.rglob("*.md")):
        try:
            lines = markdown.read_text(encoding="utf-8").splitlines()
        except OSError as error:
            issues.append(issue(markdown, 1, f"cannot read file: {error}"))
            continue
        for line_number, line in enumerate(lines, start=1):
            start = 0
            while (found := line.find(URI_START, start)) != -1:
                token = uri_token(line, found)
                issues.extend(validate_uri(token, markdown, line_number, catalogs))
                start = found + len(URI_START)
    return issues


def validate_skill(skill_path: Path | str, skill_roots: Iterable[Path | str] = ()) -> list[Issue]:
    root = Path(skill_path).resolve()
    frontmatter, _ = parse_frontmatter(root / "SKILL.md")
    name = unquote_scalar(frontmatter.get("name", "")) or root.name
    package = SkillPackage(root=root, name=name)
    roots = [Path(skill_root) for skill_root in skill_roots]
    return validate_frontmatter(package) + validate_resources(package, roots)


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate skill packages and their skill URI resources")
    parser.add_argument("skill_directory", type=Path)
    parser.add_argument("--all", action="store_true", help="Validate every direct skill package under skill_directory")
    parser.add_argument(
        "--skill-root",
        action="append",
        default=[],
        type=Path,
        help="Fallback catalog containing skill directories; first owner wins",
    )
    args = parser.parse_args()

    if args.all:
        root = args.skill_directory.resolve()
        targets = sorted(
            entry for entry in root.iterdir()
            if entry.is_dir() and (entry / "SKILL.md").is_file()
        ) if root.is_dir() else []
        roots = [root, *args.skill_root]
    else:
        targets = [args.skill_directory]
        roots = args.skill_root

    issues = [
        found
        for target in targets
        for found in validate_skill(target, roots)
    ]
    if not targets:
        print(f"no skill packages found in {args.skill_directory}", file=sys.stderr)
        return 1
    if issues:
        for found in issues:
            print(f"{found.path}:{found.line}: {found.message}", file=sys.stderr)
        return 1
    print(f"{len(targets)} skill package{'s are' if len(targets) != 1 else ' is'} valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
