# Triage labels

The five canonical triage roles, used by `/pm-triage`. Because the tracker is local markdown, a label is a `Status:` line near the top of the issue file.

| Role | Label string | Meaning |
|---|---|---|
| Needs triage | `needs-triage` | Arrived, not yet assessed |
| Needs info | `needs-info` | Blocked on a question only a human can answer |
| Ready for agent | `ready-for-agent` | Specified well enough for an agent to execute |
| Ready for human | `ready-for-human` | Needs a human — a decision, an account, a live Meta test |
| Won't fix | `wontfix` | Deliberately not doing it |

Example header:

```markdown
Status: ready-for-agent
BL: BL-16
```

## Two extra rules for this repo

1. **`ready-for-agent` requires a passed business gate.** An item cannot be marked ready without a named business problem, the KPI or P&L line it moves, and its BL id. See `/pm-build-connected`.
2. **`wontfix` still gets a line in the Master Backlog** with the reason. Silent drops are how the same idea gets re-litigated in three months.
