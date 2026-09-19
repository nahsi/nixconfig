---
name: proof-repair
description: "Own diagnosis and repair when behavior is broken and root cause is unknown: exact proof loop, minimized reproduction, falsifiable evidence, minimal patch, and real verification. Use skill://tdd only after the failure and correct seam are understood."
license: MIT
---

# Proof Repair

A tempting patch is not a repair. Build evidence for the exact failure, trace the cause, patch narrowly, and close the same proof loop.

## Phase 1 — Define and build the proof loop

1. **Gate the target.** Identify local/test/staging/production, whether the probe can mutate data or trigger external effects, and its rate, cost, privacy, and load bounds. Production writes/replays, stress traffic, paid APIs, customer data, or destructive commands require explicit user approval. Default to a local fixture, isolated test environment, read-only request, or captured redacted artifact.
2. State the exact user-visible symptom and the closest known-good behavior.
3. Redact secrets and sensitive/customer data from commands, logs, traces, screenshots, child prompts, and captured requests.
4. Build the tightest agent-runnable signal that can go red on **this** bug:
   - focused test;
   - CLI or HTTP command;
   - browser script;
   - captured input replay;
   - minimal harness;
   - differential or bisection script;
   - repeated/stressed loop for a flake;
   - measured baseline for performance.
5. Run it once within the approved bounds and record the command, output, duration, and environment.
6. Confirm it fails for the reported reason, not a nearby failure.

Reading code to construct the loop is allowed. Speculative patching before a red-capable signal is not.

If no loop is possible, stop and list what was tried and the missing artifact, access, or instrumentation. Ask only for what would make the failure observable.

## Phase 2 — Reproduce and minimize

- Re-run until the signal is deterministic. For flakes, raise and measure the reproduction rate.
- Remove inputs, callers, configuration, and steps one at a time while preserving the exact failure.
- Keep every remaining element load-bearing.
- Record the minimized case as the preferred regression seam if that seam exercises the real bug pattern.

## Phase 3 — Investigate

For non-obvious failures, write 2–5 ranked falsifiable hypotheses:

| Hypothesis | Prediction | Probe | Result |
|---|---|---|---|
| <cause> | <observable if true> | <one-variable test/log> | pending |

Then:

- read the complete error, stack, warnings, and relevant recent changes;
- trace bad values backward through callers and boundaries;
- compare the nearest working path;
- map every probe to one hypothesis;
- change one variable at a time;
- prefer debugger/REPL or targeted structured probes over “log everything.”

Use a unique marker such as `[PRIMESTACK-DEBUG-<id>]` for temporary instrumentation so cleanup is provable.

For a broad investigation, use `skill://prime-delegate` to assign **read-only, disjoint evidence sources**—history, runtime path, tests, dependency/config—not competing patches. The parent verifies the disputed facts.

## Phase 4 — Establish root cause

A root-cause claim needs:

- the causal chain from trigger to symptom;
- an observation that distinguishes it from alternatives;
- a proof-loop change predicted by the hypothesis;
- the correct fix boundary.

If three attempted fixes fail, stop stacking patches. Recheck the loop, assumptions, and architecture.

## Phase 5 — Patch minimally

- Fix the confirmed cause, not the visible symptom.
- Add a regression test only at a seam that reproduces the real pattern. A shallow tautological test is worse than a documented executable proof.
- Avoid redesign during stabilization unless the architecture prevents a correct fix; if so, name and isolate that prerequisite.
- Remove changes made for rejected hypotheses.

## Phase 6 — Close verification

1. The original proof loop is green.
2. The minimized case remains represented.
3. Nearest broader checks pass according to risk.
4. The real artifact or user surface works.
5. Temporary probes are gone.
6. Blast radius and residual risk are stated.

For performance, compare the same workload against the original baseline, report absolute and relative change, and add the cheapest useful regression guard.

## Guardrails

- No speculative patch stacks or root-cause claims without evidence.
- No broad refactor hidden inside a repair.
- No arbitrary sleeps unless the delay itself is under test; wait for conditions.
- No secrets in artifacts or child prompts.
- No parallel children editing the same repair surface.
- No “tests pass” completion when the user-facing artifact was never exercised.

## Output

- `Failure and scope`
- `Proof loop`
- `Minimized reproduction`
- `Hypotheses and evidence`
- `Root cause`
- `Patch`
- `Verification`
- `Residual risk`
