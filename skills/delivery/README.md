# delivery/

Purpose: turn a spec into shippable slices, get them out, and learn when it goes wrong.

| Skill | Load when |
|---|---|
| `to-tickets` | Spec/plan → tracer-bullet tickets with blocking edges. |
| `wayfinder` | Work too big for one session; decision tickets. |
| `triage` | Incoming issues/PRs through the state machine (`System/agents/triage-labels.md`). |
| `rollout-plan` | Deploying anything with risk: preflight, steps, signals, rollback, comms. |
| `incident-postmortem` | Outage or degradation happened; blameless write-up → vault `postmortems/`. |

Combos: `product/to-spec` → `to-tickets` → `engineering/implement` → `rollout-plan` → `qa/verification-before-completion`. Deploy itself is hook-driven (`.claude/hooks/on-push-deploy.sh`).
