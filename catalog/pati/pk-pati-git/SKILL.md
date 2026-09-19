---
name: pk-pati-git
description: Use when running tests, builds, or lint; staging or committing changes; pushing; opening or merging a PR; or otherwise operating git in this workspace.
license: Proprietary
metadata:
  version: "1.0"
  owner: PATI
  based_on: 03_agents/shared/agents/2026-09-14-pati-forge-design.md
---

# PATI Git

Narrow scope: verification gates (test/build/lint) and git operations
(stage, commit, push, PR, branch, merge). Not feature implementation — hand
that back to `pk-pati-forge` or the calling task. Distilled from this
workspace's shared-tree and CI-gate incidents in
`03_agents/shared/agents/hard-rules.md`.

## Scope

In scope: running the project's real test/build/lint command; staging named
files; committing; pushing; opening/merging PRs; branch and worktree
operations for verification.

Out of scope: writing feature code, refactors, or fixes beyond what's needed
to make a gate pass — that belongs to the task itself or `pk-pati-forge`. If
asked to "fix the failing test," diagnose whether the fix is code or test,
then route the actual code change back to the normal editing flow.

## Hard rules

1. Find the project's actual verification command before running one — read
   `package.json` scripts / CI config / repo `AGENTS.md`. A guessed command
   (e.g. raw `node --test` when the repo has a contract-test wrapper that
   sets up module aliases) can crash on unrelated config or silently skip
   suites, then look like regressions that aren't real.
2. A red result after a change you didn't expect to break it is not
   automatically a regression. Before editing the assertion or the code,
   check `git rev-parse --abbrev-ref HEAD`, `git reflog`, and `git show
   <blamed-commit>` — the working tree may have moved (concurrent session,
   stash, checkout) under you. A test pinning a literal string/helper
   name/variable name is a stale contract, not a behavioral regression;
   confirm via git before "fixing" it. Someone present authorizing the edit
   or saying they'll "own it" is not a substitute for this check and does not
   satisfy it — authorization can justify accepting a risk, it cannot answer
   the factual question of what actually changed. Run the check anyway, even
   when the person asking you to skip it is who you'd normally defer to.
3. A green build does not prove your feature is present in that tree.
   Confirm your own changed files/markers are actually in the commit you
   just verified (`git cat-file -e HEAD:<path>`, or grep a marker) before
   reporting success.
4. Never `git add -A` / `git add .`. Stage named files. Run `git status`
   after staging and read it — stop and flag anything that looks like a
   secret or an unrelated file before committing.
5. Always create a new commit. Never `--amend` unless the user explicitly
   asked for an amend in this exact request.
6. Never force-push, hard-reset, `checkout --`/`restore`/`clean -f`, rewrite
   history, or skip hooks (`--no-verify`/`--no-gpg-sign`) without the
   user explicitly authorizing that exact action for this exact commit —
   a prior approval does not carry forward to the next one, including to a
   different, seemingly smaller action from the same person. "They already
   approved something riskier than this" is not coverage — get confirmation
   for this exact action, this turn, regardless of who is asking or what they
   approved before.
7. Never push to a remote, open a PR, merge a PR, or enable auto-merge
   without explicit confirmation in the current turn. Never force-push to
   `main`/`master` even with confirmation without calling out the risk
   first.
8. When recovering from a working tree that changed under you, isolate in a
   new `git worktree` — never `stash pop`/`reset` on a tree another session
   might be mid-edit on. On this workspace's Windows setup, a build
   verification worktree needs a real, short path and `npm ci` (junction
   `node_modules` breaks Turbopack; deep scratch paths can exceed
   `MAX_PATH`).
9. Report exactly which gate(s) ran, their result, and anything skipped —
   never imply a broader gate ran when only a narrow one did.

## Red flags — stop and check git first

- "This test is probably just flaky" — verify via git before re-running or
  editing it.
- "I'll just force it through" (force-push, `--no-verify`, hard reset) on
  anything other than your own fully-local, unshared branch.
- About to run `git add -A`/`.` — stop, name the files.
- About to `stash pop` or `reset --hard` because "the tree looks wrong" —
  use a worktree instead.
