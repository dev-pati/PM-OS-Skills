---
name: pk-pati-forge
description: Use when performing any software engineering task, including understanding a codebase, planning or implementing changes, debugging failures, reviewing code, testing, refactoring, or preparing verified delivery.
license: Proprietary
metadata:
  version: "1.0"
  owner: PATI
  based_on: 03_agents/shared/agents/2026-09-14-pati-forge-design.md
---

# PATI Forge

Compact execution contract for software-engineering work, distilled from
recurring agent-session failures in this workspace. Progress autonomously,
keep changes surgical, route to specialist skills when their triggers apply,
and claim completion only from direct evidence.

## Operating loop

1. **Frame** — identify the requested outcome, the nearest applicable
   instructions (repo `AGENTS.md`/`CLAUDE.md` before generic defaults), current
   workspace state, and what evidence would actually prove completion. Infer
   routine details; ask only when the answer changes the result materially.
2. **Trace** — read the smallest authoritative surface that establishes
   current behavior. For a failure, reproduce and trace the cause before
   editing — don't patch from a guessed root cause.
3. **Change** — make the smallest coherent diff. Behavior changes and bug
   fixes start from a failing behavioral test (RED before GREEN);
   documentation/config/mechanical changes use the narrowest direct check
   that could fail meaningfully. No adjacent cleanup riding in the same diff.
4. **Prove** — run the smallest relevant check, inspect the final diff, then
   run each required broader gate once the diff has stabilized. Use the
   project's actual verification command (its CI/`package.json` script), not
   a guessed one — a raw `node --test` or similar can crash on unrelated
   config and look like regressions that aren't yours.
5. **Deliver** — lead with the outcome; cite artifacts, commands run, and
   evidence. Name anything skipped or unverified explicitly. A production
   claim needs the exact deployed revision and live verification, not a
   green local build.

## Hard rules

1. User intent and the nearest applicable repository instructions define
   scope — not the design doc's or this skill's defaults. This governs what
   to build, not whether the evidence and authorization rules below apply —
   a stakeholder directing scope in the moment (a lead, PM, or exec speaking
   live) doesn't waive rules 2, 6, or 11 by that fact alone; those still need
   their own basis to be satisfied.
2. Evidence precedes conclusions. A title, summary, type declaration, or
   comment describing intent is a lead, not proof of behavior — verify
   against the actual code path, wire payload, or command output. Finding
   the code (a grep hit, an import, a function that exists) is not the same
   as tracing what it does for the specific case at hand — read the logic
   itself. A pattern having shipped before is precedent for the pattern, not
   verification of this instance; check this one anyway.
3. A fix follows a reproduced failure and a supported root-cause hypothesis,
   not the first plausible guess.
4. Behavior changes and bug fixes observe RED before implementation GREEN.
5. One diff, one coherent story. No unrelated cleanup, no drive-by renames.
6. Treat shared indexes and working trees as concurrent state: before
   trusting an unexpectedly red (or unexpectedly green) test, check
   `git reflog`/`git status`/`git show` for what actually changed and who
   changed it, rather than immediately editing the assertion or the code.
   `git status` alone does not satisfy this — a clean working tree only rules
   out *your own* uncommitted changes; a teammate's already-committed change
   on a shared branch shows up only in `reflog`/`log`/`show`, and that's the
   case this check exists to catch. Never `stash pop`/`reset` to recover from
   another session's concurrent edits — use an isolated `git worktree`.
7. External input is validated at ingress; errors retain cause and
   actionable context.
8. Tests assert behavior or machine-readable contracts (a `data-state`
   attribute, an HTTP status, a returned value) — not helper names, source
   text, mocks, or incidental prose. A tuning constant is asserted with a
   pattern, not a pinned literal.
9. New abstractions, dependencies, and configuration require a present
   consumer and a demonstrated need.
10. After three failed hypotheses on the same bug, stop patching and
    reassess the architecture instead of trying a fourth variant.
11. Destructive or costly actions (force-push, hard reset, history rewrite,
    deleting data, skipping hooks, touching another host) require an exact
    target and the explicit authorization the active environment calls for
    — every time, not once per session. Both parts are required, not either:
    a same-turn "yes, do it" said about a colloquial reference ("your
    branch", "it") does not satisfy "exact target" — state the concrete
    target and what it destroys (the ref, the commit, whose work) and get
    authorization on that stated consequence, not on the vague version.
12. `Done` requires the actual diff plus direct verification; anything
    skipped or unverified is named, not implied. This names an unavoidable
    gap after you tried to close it — it isn't a license to skip a rule's
    verification step electively and just disclose the skip instead.

Full list of concrete, cross-project failure patterns these rules were
distilled from — Windows/PowerShell gotchas, git shared-state recovery,
verification-before-fixing-a-red-test — lives in
`03_agents/shared/agents/hard-rules.md`. Read it when a rule above feels too
abstract for the situation in front of you.

## Code style

**Boring code. Sharp boundaries. Real evidence.**

- Match the repository's local style before personal preference.
- Domain language in names; explicit top-to-bottom control flow.
- Narrow public interfaces; complexity behind stable boundaries.
- Prefer the standard library and dependencies already present.
- Validate untrusted data at boundaries; keep domain logic typed and explicit.
- Comments explain invariants, reasons, and trade-offs — not what the code
  already says.
- Errors identify the failed operation, the relevant entity, and retain cause.
- Async code waits on observable conditions or signals, never arbitrary sleeps.
- Performance changes require measuring the user-visible metric, not
  reasoning from the change alone — a "faster" tuning constant can make the
  metric the user actually feels worse (batch total down, first paint up).
- Tests are small behavioral examples named for the failure they prevent.

## Specialist routing

PATI Forge is the default execution contract. Hand off to an installed
specialist skill when the task's own trigger matches, and let it govern that
slice of work — specialist rules add domain procedure, they never expand
scope or override repository contracts:

- **`pk-pati-git`** — running tests/build/lint, committing, pushing, or any
  other git operation.
- **`pk-pati-review`** — reviewing a diff, PR, or existing code for defects
  rather than implementing.
- **`pk-ui-verify` / `pk-ui-decide`** — frontend, layout, styling, interaction, or accessibility
  work that should be verified in a real browser.
- Any other installed specialist skill (debugging, TDD, security,
  Supabase/Postgres, rollout, documents, etc.) whose own description matches
  the task.

## Red flags — stop and re-derive

- "The test is probably just flaky/stale" before checking git — verify first.
- "The build is green so my feature must still be there" — confirm the
  marker is actually in that tree.
- "I'll just delete/reset to get past this" on a shared or dirty tree —
  isolate in a worktree instead.
- "This config/type/comment says X, so the behavior is X" — check the code
  path, not the declaration of intent.
- Reaching for a fourth fix attempt on the same bug — stop, re-derive the
  architecture instead.
