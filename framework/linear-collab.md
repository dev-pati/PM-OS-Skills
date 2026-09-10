# Linear for collaborative work

How a PM and one or more agents share one Linear issue as the progress record.
Companion to [pm-operating-system.md](pm-operating-system.md) Phase B.

> **Status: proposed operating design, 08/09/2026.** Not yet accepted as team process.
> Tool names match the Linear MCP interface connected at that date. Verify before automating.

## The contract

One issue. One accountable executor. Work advances through explicit gates.
Linear is the shared progress record, not a chat log.

**Every stage writes a checkpoint before it advances.** Never imply a successful
Linear update when the write failed or is unconfirmed.

## Seven stages, three gates

| # | Stage | What it does | MCP write |
|---|---|---|---|
| 01 | Take one eligible issue | Confirm scope, owner, blockers, current state | `save_issue` + `save_comment` |
| 02 | Pass the issue prompt to an agent | Issue ID + title/description + target repo. **No bulk read** | `save_comment` |
| 03 | Agent understands the actual problem | Targeted evidence only; return diagnosis + blockers | `save_comment` |
| 04 | Design the smallest implementation | Reuse first; affected files; tests; rollback if needed | `save_comment` |
| — | **GATE · Plan approved?** | A **human** approves scope. Otherwise pause or revise | `save_comment` |
| 05 | Implement the approved change | Minimal diff + regression test; preserve other people's work | `save_comment` |
| 06A | Local testing | Regression + acceptance; every required check | `save_comment` |
| — | **GATE · Review + deploy authorized?** | Human review; merge/release authorized if required | `save_issue` + `save_comment` |
| 06B | Production testing | Safe smoke + critical paths + logs on the live revision | `save_comment` (+ `save_issue` on failure) |
| — | **GATE · Observe + accept** | Agreed duration, signals, thresholds, responsible owner | `save_comment` |
| 07 | Complete the issue | Local + production passed; observation accepted | `save_comment` → `save_issue` → `get_issue` verify |

**These seven stages are not seven new Linear statuses.** Keep the team's existing
workflow states. A stage is a checkpoint, not a state machine.

## What each checkpoint says

```text
[run <id> · <stage> · attempt <n> · <timestamp>]
- Result:   what changed, or what the check established
- Evidence: exact command + result; file / artifact / commit if available
- Blocker:  none, or the specific failure + responsible owner
- Next:     one action and who performs it
```

Four lines. No narration, no adjectives, no "should work now".

## One thread, real evidence

1. Create **one root progress comment**. Save its returned ID.
2. Every later update is `save_comment(parentId, body)` — stage entries, decisions, test attempts.
3. Post on stage entry and outcome. Combine adjacent transitions where possible.
4. **Refresh the issue and its comments** before implementing, reviewing, closing, or resuming.

Without step 4 you will overwrite someone else's update.

## Delegate, not bulk-read

Use the supplied issue prompt, or `get_issue` for title and description.
Pass that directly to the agent with the target repo.

Agent prompt: *understand the actual problem and design the minimal fix.*
The agent retrieves its own targeted evidence. It does not read the whole tracker.

**The parent owns MCP checkpoints and approvals.** The subagent diagnoses and fixes.
A subagent that writes its own Linear state breaks the single-thread contract.

## Failure and blockers

Preserve evidence. Stop advancement. **Never blindly redeploy.**

- **Local failure** → send the failure evidence to the same agent. Diagnose → minimal fix → local retest → back to the plan gate.
- **Production impact** → contain or roll back under the authorized runbook, then diagnose.
- **Failed deploy** → record the failure and verify which version is actually serving. Do not claim tests ran against a revision that never shipped.
- **Later regression** → reopen the original issue for the same unmet acceptance criteria; create a linked bug for a genuinely new defect. Feed the evidence back.

## Bound the loop

Suggested default: **pause after three unsuccessful fix attempts**, or at the agreed time limit.

A skipped required test is not a pass.
A green test run is not a deployment.
Ad-created is not the same as active.

## Production safety

Use read-only checks, or approved test accounts with reversible test data.
Set the observation window and thresholds **before** deploying, not after.

## Triage labels

Five canonical roles — see [triage-labels.md](triage-labels.md).
`ready-for-agent` **requires a passed Gate 1** (Business, B1–B9) from
[product-development-framework.md](product-development-framework.md).

## Checkpoint failure modes

| Situation | What to do |
|---|---|
| Write failed or ambiguous | Keep the checkpoint locally. Pause progression. Read the issue back before retrying |
| Resuming a run | Recover run ID, root comment ID, last confirmed checkpoint, current working state |
| Two agents on one issue | Not supported. One accountable executor per issue |

## Start small

One executor. One issue. Manual invocation. MCP is the read/write interface, not an autopilot.

## Related

- [pm-operating-system.md](pm-operating-system.md) — the three phases this sits inside
- [product-development-framework.md](product-development-framework.md) — the gates upstream
- [issue-tracker.md](issue-tracker.md) — tracker conventions
- [triage-labels.md](triage-labels.md) — the five labels
- `canvas/linear-collab-loop.workflow.json` — diagram spec
- `outputs/linear-feedback-loop.html` — original design render

