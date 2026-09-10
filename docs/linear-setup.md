# Linear setup for collaborative work

The framework treats Linear as the **shared progress record**, not a chat log.
Read [framework/linear-collab.md](../framework/linear-collab.md) for the loop itself;
this page is the wiring.

> **Status: proposed, 08/09/2026.** Tool names below match the Linear MCP interface
> connected on that date. Verify against your own MCP server before automating.

## 1. Connect the MCP server

Linear ships an MCP endpoint. Add it to your agent runtime config — for Claude Code
that is `.mcp.json` at the workspace root:

```json
{
  "mcpServers": {
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app/mcp"
    }
  }
}
```

Restart the agent, then confirm the tools resolve before relying on them:

```text
list_issues   read the queue
get_issue     one issue, title + description
save_issue    change state, assignee, labels
save_comment  append to the progress thread
```

If a tool name differs on your server, fix the names in
`framework/linear-collab.md` rather than guessing at call time.

## 2. Decide the label set

The framework uses five triage roles — see
[framework/triage-labels.md](../framework/triage-labels.md):

```text
needs-triage      arrived, not yet assessed
needs-info        blocked on a question only a human can answer
ready-for-agent   specified well enough for an agent to execute
ready-for-human   needs a human: a decision, an account, an approval
wontfix           deliberately not doing it
```

Create these as Linear **labels**, not workflow states. Keep your team's existing
states. `ready-for-agent` is the one that carries a hard precondition: **Gate 1
must have passed**, so the issue names its persona, pain, KPI, and adoption
hypothesis before an agent touches it.

## 3. Open one progress thread per issue

At stage 01, create a **single root comment** and keep its returned ID for the run.
Every later update is `save_comment(parentId, body)`.

Root comment:

```text
[run <id> · started <timestamp> · owner <name>]
Scope:    <one sentence>
Gate 1:   passed <date> / not required (one-line bug)
Next:     <stage 02, who>
```

Stage entry:

```text
[run <id> · <stage> · attempt <n> · <timestamp>]
- Result:   what changed, or what the check established
- Evidence: exact command + result; file / artifact / commit
- Blocker:  none, or the specific failure + responsible owner
- Next:     one action and who performs it
```

Four lines. No "should be fine", no "looks good now".

## 4. Refresh before you write

Always `get_issue` and re-read the thread before implementing, reviewing, closing,
or resuming. Two agents writing from stale state is the main way this loop corrupts.

## 5. Who owns what

| Actor | Owns |
|---|---|
| **PM / parent agent** | MCP checkpoints, gate approvals, the run ID, the root comment |
| **Subagent** | Diagnosis and the minimal fix. Reports back; does **not** write Linear state |
| **Human reviewer** | The plan gate and the deploy gate. Neither can be self-approved |

One accountable executor per issue. Two agents on one issue is not supported.

## 6. Stop rules

- Three failed fix attempts → pause, escalate, say so in the thread.
- Production impact → contain or roll back under the authorized runbook, **then** diagnose.
- A failed write → keep the checkpoint locally, pause, read the issue back. Never
  imply a Linear update that did not land.

## 7. Resuming a run

Recover four things: the run ID, the root comment ID, the last **confirmed**
checkpoint, and the current working state on disk. If any is missing, re-establish
it before advancing.

## Reporting commits back

`Knowledge/linear-progress-reporter.md` in the PATI vault documents a script that
maps new commits to issues and renders comment bodies. It reads git only; Linear
reads and writes stay in the agent session over MCP, so no API key is stored.
That tool is PATI-specific and is **not** bundled here.

