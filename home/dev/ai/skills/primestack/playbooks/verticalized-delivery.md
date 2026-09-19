# Verticalized delivery playbook

Use when a plan must become locally durable, independently executable work without issue-tracker spam.

1. Run [`verticalize-work`](skill://verticalize-work) and default to `.scratch/work/<slug>/` for durable/multi-agent plans.
2. Freeze the final outcome, non-goals, and integration verification.
3. Create the thinnest tracer slice, then depth slices. Reject horizontal backend/frontend/tests sludge unless it creates standalone verified value.
4. Record a minimal dependency DAG and the current independent frontier.
5. Execute each ready slice with [`implement`](skill://implement) or the narrower matching leaf. Before OMP task dispatch, run [`prime-delegate`](skill://prime-delegate); assign one child per slice with disjoint ownership and an explicit terminal-result contract.
6. Admit only the current frontier, then continue available coordinator work while results auto-deliver. Later waves start only after dependencies are parent-verified.
7. The root integrates and checks the whole outcome. Child completion does not imply project completion.
8. Reshape locally when hidden decisions appear. Publish tracker issues only if the user asks.
