---
name: tdd
description: Deliver behavior changes through one vertical red-green-refactor slice at a time, testing through stable public seams. Use when the user requests TDD/test-first work, a regression test is cheap and representative, or a shaped contract names test seams.
license: MIT
---

# TDD

Use tests as an executable behavior contract, not implementation surveillance.

## Entry gate

Before writing a test, name:

- the observable behavior;
- the stable public seam or closest real boundary;
- why this test would fail if the behavior is absent or broken;
- the cheapest command that runs it.

If the only possible test is tautological, brittle, or much more expensive than the change, use the closest executable proof and state why. Do not build a large harness merely to claim TDD.

## Loop

For each vertical behavior slice:

1. **Red**
   - Write one focused behavior test through the agreed seam.
   - Derive expected values independently from the implementation.
   - Run the narrowest command.
   - Confirm it fails for the expected missing behavior, not setup noise.
2. **Green**
   - Make the smallest coherent production change that satisfies the behavior.
   - Run the focused test until green.
   - Do not pre-build later slices.
3. **Refactor while green**
   - Remove duplication and improve names/shape without changing behavior.
   - Keep the focused test green after each meaningful change.
4. **Broaden by risk**
   - Run adjacent tests, typecheck/build/lint where relevant, then the real surface.
5. **Preserve the proof story**
   - Leave the slice green and independently reviewable before advancing. Create a Git commit only when the user requested or authorized repository-history changes.

## Test quality

Prefer tests that:

- exercise a public interface, observable effect, or real adapter boundary;
- survive internal refactors;
- cover an important example or invariant;
- fail with a useful signal;
- avoid mocks unless the boundary itself is the contract.

For bugs, use `skill://proof-repair` first to minimize the actual failure, then preserve it at the correct seam.

## Guardrails

- No production code before a meaningful red signal when operating test-first.
- No test written to match the current implementation line-for-line.
- No broad batch of red tests before implementation feedback.
- No hidden horizontal “all tests later” slice.
- No weakening assertions to obtain green.
- No completion based only on the unit test when integration or user-surface risk remains.

## Output

- `Behavior and seam`
- `Red command and expected failure`
- `Green implementation`
- `Refactor`
- `Broader verification`
- `Remaining risk/next slice`
