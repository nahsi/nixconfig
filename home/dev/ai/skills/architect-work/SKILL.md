---
name: architect-work
description: Design or refactor module boundaries, types, interfaces, ownership, and migration paths before implementation. Use when code is shallow, tangled, hard to test, reader-heavy, or when a feature needs a durable architecture rather than another wrapper.
license: MIT
---

# Architect Work

Design from observed friction and the intended end state. Prefer deeper modules, fewer concepts, illegal states made unrepresentable, and deletion over compatibility scaffolding.

## Workflow

1. **Observe friction.** Cite the change paths, repeated branching, leaked knowledge, call chains, duplicate validation, or test pain that justify design work.
2. **Map the current contract.** Identify callers, public interface, invariants, state ownership, boundaries, and the closest tests. Use `skill://context-map` when this is unclear.
3. **State the end state.** Design as if the current requirement had been foundational, while respecting real external/persisted contracts.
4. **Subtract first.** Find dead paths, wrappers, flags, fallback masks, duplicated guards, and speculative abstraction that can be deleted before adding structure.
5. **Generate alternatives.** Sketch 2–3 materially different shapes with types/signatures/module boundaries. For consequential choices, use `skill://prime-delegate` arena mode with the same contract and rubric.
6. **Evaluate:**
   - interface size versus capability depth;
   - locality and reader load;
   - invariant/type strength;
   - testability through the public seam;
   - boundary and failure behavior;
   - migration/deletion cost;
   - operational and concurrency safety.
7. **Choose and pressure-test.** Walk two real scenarios and one edge/failure scenario through the proposed shape.
8. **Plan the transition.** Characterize current behavior where needed; migrate callers; delete the old API and residue in the same bounded wave when safe. Use expand→migrate→contract only for genuinely wide changes.
9. **Hand off.** A recommendation that depends on user priorities remains proposed until shape-work's Shared understanding discussion confirms it. Use `skill://verticalize-work` when execution spans multiple independently verifiable units.

## Design heuristics

- A deep module hides substantial complexity behind a small coherent interface.
- One adapter can be hypothetical; two independent adapters prove a seam.
- Validate at system boundaries, not repeatedly inside the trusted core.
- Keep state with the component that enforces its invariants.
- Separate shared mutable state before trying to serialize access to it.
- A deletion test is strong: if removing the module barely changes callers, it may be shallow ceremony.
- Optimize for the maintainer's question-to-answer distance, not diagram symmetry.

## Guardrails

- No architecture work without observed friction or a real new requirement.
- No generic repository pattern imposed over stronger local conventions.
- No interface that exposes internal workflow step-by-step.
- No compatibility layer without a named external constraint and deletion trigger.
- No arena whose candidates are cosmetic variants.
- No large implementation before the chosen shape survives scenario walkthroughs.

## Output

- `Observed friction`
- `Current contract and constraints`
- `Intended end state`
- `Alternatives and tradeoffs`
- `Chosen types/interfaces/modules`
- `Scenario pressure test`
- `Migration and deletion plan`
- `Verification seams`
