from __future__ import annotations

import importlib.util
import tempfile
import unittest
import sys
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "quick_validate.py"
SPEC = importlib.util.spec_from_file_location("quick_validate", SCRIPT)
quick_validate = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = quick_validate
assert SPEC.loader is not None
SPEC.loader.exec_module(quick_validate)


class QuickValidateTests(unittest.TestCase):
    def write_skill(self, root: Path, name: str, body: str = "") -> Path:
        package = root / name
        package.mkdir(parents=True)
        (package / "SKILL.md").write_text(
            f"---\nname: {name}\ndescription: A test skill.\n---\n{body}",
            encoding="utf-8",
        )
        return package

    def test_resolves_target_and_ordered_catalog_resources(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            target = self.write_skill(root / "target-catalog", "target", "Use skill://target/scripts/check.py and skill://other/references/rules.md.\n")
            (target / "scripts").mkdir()
            (target / "scripts" / "check.py").write_text("", encoding="utf-8")
            other = self.write_skill(root / "catalog", "other")
            (other / "references").mkdir()
            (other / "references" / "rules.md").write_text("rules\n", encoding="utf-8")

            self.assertEqual([], quick_validate.validate_skill(target, [root / "catalog"]))

    def test_reports_malformed_uri_at_source_line(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            package = self.write_skill(Path(temporary), "sample", "\nResource: skill://sample/../secret.txt\n")

            issues = quick_validate.validate_skill(package)

            self.assertEqual(1, len(issues))
            self.assertEqual(6, issues[0].line)
            self.assertIn("escaping", issues[0].message)

    def test_reports_unknown_owner_and_missing_resource(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            package = self.write_skill(
                root,
                "sample",
                "Use skill://unknown/references/rules.md and skill://sample/references/missing.md.\n",
            )

            issues = quick_validate.validate_skill(package)

            self.assertEqual(2, len(issues))
            self.assertIn("owner not found", issues[0].message)
            self.assertIn("resource not found", issues[1].message)

    def test_rejects_empty_required_frontmatter(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            package = Path(temporary) / "sample"
            package.mkdir()
            (package / "SKILL.md").write_text(
                "---\nname: \"\"\ndescription: \"\"\n---\n",
                encoding="utf-8",
            )

            issues = quick_validate.validate_skill(package)

            self.assertEqual(
                {"name cannot be empty", "description cannot be empty"},
                {found.message for found in issues},
            )

    def test_catalog_uses_first_owner(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            target = self.write_skill(root / "target", "target", "Use skill://other/references/rules.md.\n")
            first = self.write_skill(root / "first", "other")
            second = self.write_skill(root / "second", "other")
            (second / "references").mkdir()
            (second / "references" / "rules.md").write_text("rules\n", encoding="utf-8")

            issues = quick_validate.validate_skill(target, [first, second])

            self.assertEqual(1, len(issues))
            self.assertIn("resource not found", issues[0].message)

    def test_accepts_camel_case_invocation_flag(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            package = Path(temporary) / "sample"
            package.mkdir()
            (package / "SKILL.md").write_text(
                "---\nname: sample\ndescription: A test skill.\ndisableModelInvocation: true\n---\n",
                encoding="utf-8",
            )

            self.assertEqual([], quick_validate.validate_skill(package))


if __name__ == "__main__":
    unittest.main()
