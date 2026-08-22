---
name: create-skill
description: Create, revise, and evaluate OMP skills. Use when authoring or changing SKILL.md files, testing whether a skill improves agent behavior, or reviewing skill invocation and structure.
---

# Create skill

Create or improve an OMP skill through a draft, behavioral evaluation, user review, and revision loop.

Read `skill://writing-for-agents` and `skill://writing-for-agents/SKILL-MECHANICS.md` before drafting. That skill is authoritative for OMP invocation, descriptions, information hierarchy, pointers, and pruning. This skill owns the surrounding authoring and evaluation workflow.

At a high level:

1. Decide what the skill should do and when it should run.
2. Draft the skill and any reusable resources.
3. Create realistic test prompts.
4. Run isolated OMP `task` agents with the draft and against a baseline.
5. Grade observable assertions and give the outputs to the user for review.
6. Revise from evidence and user feedback.
7. Repeat until the user is satisfied or another iteration no longer improves the result.

Join the workflow at the stage the user has already reached. Existing drafts can start at evaluation. Subjective mode skills usually need a user vibe-check rather than forced quantitative assertions.

## Communicating with the user

Match the user's vocabulary. Briefly define evaluation terms only when the conversation suggests they are unfamiliar.

## Creating a skill

### Capture intent

Extract answers from the current conversation before asking:

1. What should the skill enable an OMP agent to do?
2. When should it run?
3. What output or side effect should it produce?
4. Which outcomes are objectively testable?
5. Is it personal (`~/.omp/agent/skills/<name>/`) or project-local (`.omp/skills/<name>/`)?

Ask only for missing product or preference decisions. Infer repository facts from files and tools.

### Interview and research

Resolve edge cases, input and output formats, examples, success criteria, and dependencies before writing tests. Use mounted MCPs and parallel OMP `task` agents when independent research slices exist.

### Write the SKILL.md

Choose the invocation contract first:

- **Model-invoked:** omit `disable-model-invocation`; write a model-facing description containing the real trigger branches.
- **User-invoked:** set `disable-model-invocation: true`; write a short human-facing summary and document `/skill:<name>`.

Then define:

- **name:** kebab-case skill identifier.
- **description:** the invocation pointer described above.
- **body:** ordered steps and reference needed on every branch.
- **resources:** scripts, references, or assets that should load only when needed.

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

OMP skills use three loading levels:

1. **Metadata** — name and description are available for model-invoked skills.
2. **SKILL.md body** — loaded through `skill://<name>` or `/skill:<name>`.
3. **Bundled resources** — loaded or executed only when a pointer reaches them.

The size limits are guidance, not validation rules.

**Key patterns:**
- Keep SKILL.md under 500 lines; if you're approaching this limit, add an additional layer of hierarchy along with clear pointers about where the model using the skill should go next to follow up.
- Reference files clearly from SKILL.md with guidance on when to read them
- For large reference files (>300 lines), include a table of contents

**Domain organization**: When a skill supports multiple domains/frameworks, organize by variant:
```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```
The agent reads only the relevant reference file.

#### Principle of Lack of Surprise

This goes without saying, but skills must not contain malware, exploit code, or any content that could compromise system security. A skill's contents should not surprise the user in their intent if described. Don't go along with requests to create misleading skills or skills designed to facilitate unauthorized access, data exfiltration, or other malicious activities. Things like a "roleplay as an XYZ" are OK though.

#### Writing Patterns

Prefer using the imperative form in instructions.

**Defining output formats** - You can do it like this:
```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples pattern** - It's useful to include examples. You can format them like this (but if "Input" and "Output" are in the examples you might want to deviate a little):
```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Writing Style

Try to explain to the model why things are important in lieu of heavy-handed musty MUSTs. Use theory of mind and try to make the skill general and not super-narrow to specific examples. Start by writing a draft and then look at it with fresh eyes and improve it.

### Test Cases

After writing the skill draft, come up with 2-3 realistic test prompts — the kind of thing a real user would actually say. Share them with the user: [you don't have to use this exact language] "Here are a few test cases I'd like to try. Do these look right, or do you want to add more?" Then run them.

Save test cases to `evals/evals.json`. Don't write assertions yet — just the prompts. You'll draft assertions in the next step while the runs are in progress.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

See `skill://create-skill/references/schemas.md` for the full schema (including the `assertions` field, which you'll add later).

## Running and evaluating test cases

Run this section as one continuous sequence. Do not substitute source inspection for behavioral evidence.

Put results in `<skill-name>-workspace/` beside the skill directory, grouped by iteration and eval ID:

```text
<skill-name>-workspace/
└── iteration-1/
    └── eval-<id>/
        ├── eval_metadata.json
        ├── primary/run-<n>/{outputs/,grading.json,timing.json}
        └── baseline/run-<n>/{outputs/,grading.json,timing.json}
```
Keep the workspace untracked unless the user wants the evaluation trail committed.

### Step 1: Spawn draft and baseline runs together

`task.isolation.mode` must be enabled so each task item accepts `isolated: true`. If the field is unavailable, report the configuration prerequisite instead of claiming an isolated evaluation.

For every test prompt, launch two built-in OMP `task` agents in one batch:

- **Primary:** `isolated: true`; give the exact draft skill path and require the agent to read it before executing the prompt.
- **Baseline:** `isolated: true`; use no skill for a new skill, or a snapshot of the old version for an existing skill.

Use the same configured `task` model. This workflow measures the skill, not model differences. Give both runs the same task prompt and inputs. Assign disjoint output paths. Prose-only results may stay in `agent://<id>` artifacts; file-producing tasks write into their assigned workspace paths.

For an existing skill, snapshot the baseline before editing:

```bash
cp -R <skill-path> <workspace>/skill-snapshot
```

Write `eval_metadata.json` for each test:

```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name",
  "prompt": "The user's task prompt",
  "assertions": []
}
```

### Step 2: Draft assertions while tasks run

Draft objective, named assertions and explain them to the user. Reuse or revise assertions from `evals/evals.json` when present. Keep subjective quality in the human review instead of manufacturing a numeric proxy.

Update `eval_metadata.json` and `evals/evals.json` before grading.

### Step 3: Capture OMP task metrics

As each task settles, save its `tokens` and `durationMs` fields to that run's `timing.json`:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332
}
```

Read full outputs from `agent://<id>` before grading. A completed task status is not evidence that the artifact is correct.

### Step 4: Grade, aggregate, and generate the review

1. **Grade each run.** Spawn an OMP `task` agent with `skill://create-skill/agents/grader.md`, the assertions, and the output paths. For programmatically checkable assertions, write and run a deterministic script. Save `grading.json` with `text`, `passed`, and `evidence` fields.
2. **Aggregate the benchmark.**

   ```bash
   python skill://create-skill/scripts/aggregate_benchmark.py <workspace>/iteration-N --skill-name <name>
   ```

   Every eval has matched, non-empty `primary` and `baseline` `run-N` sets. Each run contains `outputs/`, `grading.json`, and `timing.json`; each eval contains `eval_metadata.json`. Aggregation writes `benchmark.json` and `benchmark.md` with primary before baseline and numeric primary-minus-baseline deltas.
3. **Analyze the result.** Read the benchmark and apply `skill://create-skill/agents/analyzer.md`. Save its JSON array to `<workspace>/iteration-N/analysis.json`, then regenerate the benchmark with those notes:

   ```bash
   python skill://create-skill/scripts/aggregate_benchmark.py \
     <workspace>/iteration-N \
     --skill-name <name> \
     --notes <workspace>/iteration-N/analysis.json
   ```
4. **Generate a static review file.**

   ```bash
   python skill://create-skill/eval-viewer/generate_review.py \
     <workspace>/iteration-N \
     --skill-name "<name>" \
     --benchmark <workspace>/iteration-N/benchmark.json \
     --static <workspace>/iteration-N/review.html
   ```

   For iteration 2 and later, also pass `--previous-workspace`.
5. Report the exact `review.html` path. The user reviews outputs and metrics, then exports `feedback.json`.

### What the user sees in the viewer

The "Outputs" tab shows one test case at a time:
- **Prompt**: the task that was given
- **Output**: the files the skill produced, rendered inline where possible
- **Previous Output** (iteration 2+): collapsed section showing last iteration's output
- **Formal Grades** (if grading was run): collapsed section showing assertion pass/fail
- **Feedback**: a textbox that auto-saves as they type
- **Previous Feedback** (iteration 2+): their comments from last time, shown below the textbox

The "Benchmark" tab shows the stats summary: pass rates, timing, and token usage for each configuration, with per-eval breakdowns and analyst observations.

Navigation is via prev/next buttons or arrow keys. When done, they click "Submit All Reviews" which saves all feedback to `feedback.json`.

### Step 5: Read the feedback

When the user tells you they're done, read `feedback.json`:

```json
{
  "reviews": [
    {"run_id": "eval-0-primary-run-1", "feedback": "the chart is missing axis labels", "timestamp": "..."},
    {"run_id": "eval-1-primary-run-1", "feedback": "", "timestamp": "..."},
    {"run_id": "eval-2-primary-run-1", "feedback": "perfect, love this", "timestamp": "..."}
  ],
  "status": "complete"
}
```

Empty feedback means the user thought it was fine. Focus your improvements on the test cases where the user had specific complaints.


---

## Improving the skill

This is the heart of the loop. You've run the test cases, the user has reviewed the results, and now you need to make the skill better based on their feedback.

### How to think about improvements

1. **Generalize from the feedback.** The big picture thing that's happening here is that we're trying to create skills that can be used a million times (maybe literally, maybe even more who knows) across many different prompts. Here you and the user are iterating on only a few examples over and over again because it helps move faster. The user knows these examples in and out and it's quick for them to assess new outputs. But if the skill you and the user are codeveloping works only for those examples, it's useless. Rather than put in fiddly overfitty changes, or oppressively constrictive MUSTs, if there's some stubborn issue, you might try branching out and using different metaphors, or recommending different patterns of working. It's relatively cheap to try and maybe you'll land on something great.

2. **Keep the prompt lean.** Remove things that aren't pulling their weight. Make sure to read the transcripts, not just the final outputs — if it looks like the skill is making the model waste a bunch of time doing things that are unproductive, you can try getting rid of the parts of the skill that are making it do that and seeing what happens.

3. **Explain the why.** Try hard to explain the **why** behind everything you're asking the model to do. Today's LLMs are *smart*. They have good theory of mind and when given a good harness can go beyond rote instructions and really make things happen. Even if the feedback from the user is terse or frustrated, try to actually understand the task and why the user is writing what they wrote, and what they actually wrote, and then transmit this understanding into the instructions. If you find yourself writing ALWAYS or NEVER in all caps, or using super rigid structures, that's a yellow flag — if possible, reframe and explain the reasoning so that the model understands why the thing you're asking for is important. That's a more humane, powerful, and effective approach.

4. **Look for repeated work across test cases.** Read the transcripts from the test runs and notice if the subagents all independently wrote similar helper scripts or took the same multi-step approach to something. If all 3 test cases resulted in the subagent writing a `create_docx.py` or a `build_chart.py`, that's a strong signal the skill should bundle that script. Write it once, put it in `scripts/`, and tell the skill to use it. This saves every future invocation from reinventing the wheel.

This task is pretty important (we are trying to create billions a year in economic value here!) and your thinking time is not the blocker; take your time and really mull things over. I'd suggest writing a draft revision and then looking at it anew and making improvements. Really do your best to get into the head of the user and understand what they want and need.

### The iteration loop

After improving the skill:

1. Apply your improvements to the skill
2. Rerun all test cases into a new `iteration-<N+1>/` directory, creating matched `primary` and `baseline` runs. For a new skill, primary uses the revised skill and baseline uses no skill. For an existing skill, choose the original version or previous iteration as baseline.
3. Launch the reviewer with `--previous-workspace` pointing at the previous iteration
4. Wait for the user to review and tell you they're done
5. Read the new feedback, improve again, repeat

Keep going until:
- The user says they're happy
- The feedback is all empty (everything looks good)
- You're not making meaningful progress

---

## Advanced: Blind comparison

For a rigorous comparison between two skill versions, read `skill://create-skill/agents/comparator.md` and `skill://create-skill/agents/analyzer.md`. Give anonymous outputs to an independent OMP `task` agent, then analyze why the winner won.

This is optional. It compares skill versions using the configured `task` model; it does not claim cross-model agreement.

---

## Description review

For a model-invoked skill, offer to review its description after the behavioral workflow is stable. Skip this section for skills with `disable-model-invocation: true`.

### Step 1: Generate trigger queries

Create 20 realistic queries split between should-trigger and difficult near-miss cases:

```json
[
  {"query": "the user prompt", "should_trigger": true},
  {"query": "a nearby but different request", "should_trigger": false}
]
```

Use substantive prompts with real detail, varied wording, typos, and competing skills. Obvious negatives do not test the description.

### Step 2: Review queries with the user

1. Read `skill://create-skill/assets/eval_review.html`.
2. Replace its eval, skill-name, and description placeholders.
3. Write a static HTML file under the evaluation workspace.
4. Report the path so the user can review and export the set.

Bad queries produce bad descriptions; do not optimize against an unreviewed set.

### Step 3: Review the description qualitatively

The upstream automated optimizer depended on fresh external CLI processes. It is intentionally not ported: this OMP setup uses `task` agents and does not launch headless OMP processes for trigger benchmarks.

Use `skill://writing-for-agents/SKILL-MECHANICS.md` to inspect branch coverage, leading words, false-positive near misses, and whether the skill should be model- or user-invoked. You may ask OMP `task` agents to critique the query set against the name and description, but label that result qualitative. Do not report a measured trigger rate.

### Step 4: Apply the result

Show the description before and after. Update it only after the user accepts the trigger branches and tradeoff.
---

## Reference files

The agents/ directory contains instructions for specialized subagents. Read them when you need to spawn the relevant subagent.

- `skill://create-skill/agents/grader.md` — How to evaluate assertions against outputs
- `skill://create-skill/agents/comparator.md` — How to do blind A/B comparison between two outputs
- `skill://create-skill/agents/analyzer.md` — How to analyze why one version beat another

The reference schema is `skill://create-skill/references/schemas.md`.

---

The core loop:

1. Understand the skill.
2. Draft or edit it using `skill://writing-for-agents`.
3. Run isolated with-skill and baseline tasks.
4. Grade observable assertions and generate the static review.
5. Revise from evidence and user feedback.
6. Repeat until another iteration no longer helps.
7. Run `python skill://create-skill/scripts/quick_validate.py <skill-directory> --skill-root <skill-catalog>` and verify every pointer and asset before returning the skill.

Track every applicable step in the OMP todo list. Do not stop between spawning evaluations and producing the human review artifact.
