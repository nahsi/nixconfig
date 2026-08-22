from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).parents[2] / "eval-viewer" / "generate_review.py"
SPEC = importlib.util.spec_from_file_location("generate_review", SCRIPT)
generate_review = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = generate_review
assert SPEC.loader is not None
SPEC.loader.exec_module(generate_review)


class GenerateReviewTests(unittest.TestCase):
    def test_fixed_layout_loads_eval_metadata(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workspace = Path(temporary)
            eval_dir = workspace / "eval-1"
            eval_dir.mkdir()
            (eval_dir / "eval_metadata.json").write_text(
                json.dumps({
                    "eval_id": 1,
                    "eval_name": "Documented layout",
                    "prompt": "Do the work",
                    "assertions": [],
                }),
                encoding="utf-8",
            )
            run = eval_dir / "primary" / "run-1"
            outputs = run / "outputs"
            outputs.mkdir(parents=True)
            (outputs / "result.txt").write_text("result\n", encoding="utf-8")
            (run / "grading.json").write_text(
                json.dumps({"summary": {"pass_rate": 1.0}}),
                encoding="utf-8",
            )

            runs = generate_review.find_runs(workspace)

            self.assertEqual(1, len(runs))
            self.assertEqual(1, runs[0]["eval_id"])
            self.assertEqual("Do the work", runs[0]["prompt"])
            self.assertEqual("eval-1-primary-run-1", runs[0]["id"])

    def test_embedded_data_escapes_script_terminators(self) -> None:
        attack = "</script><script>alert('x')</script>"

        html = generate_review.generate_html(
            [{"id": "run", "prompt": attack, "outputs": []}],
            "sample",
        )

        self.assertNotIn(attack, html)
        self.assertIn("\\u003c/script\\u003e", html)

    def test_explicit_missing_benchmark_fails(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workspace = Path(temporary)
            outputs = workspace / "eval-1" / "primary" / "run-1" / "outputs"
            outputs.mkdir(parents=True)
            (outputs / "result.txt").write_text("result\n", encoding="utf-8")
            review = workspace / "review.html"

            result = subprocess.run(
                [
                    sys.executable,
                    str(SCRIPT),
                    str(workspace),
                    "--benchmark",
                    str(workspace / "missing.json"),
                    "--static",
                    str(review),
                ],
                capture_output=True,
                text=True,
                check=False,
            )

            self.assertNotEqual(0, result.returncode)
            self.assertFalse(review.exists())


if __name__ == "__main__":
    unittest.main()
