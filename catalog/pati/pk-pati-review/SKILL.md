---
name: pk-pati-review
description: Use when reviewing a diff, pull request, or existing code for defects, risk, or quality — as a review pass rather than implementing a change.
license: Proprietary
metadata:
  version: "1.0"
  owner: PATI
  based_on: 03_agents/shared/agents/2026-09-14-pati-forge-design.md
---

# PATI Review

Narrow scope: produce review findings on a diff or existing code. Does not
implement fixes unless the user explicitly asks for that as a separate step.
Distilled from this workspace's history of contract tests and stale pins
being mistaken for (or hiding) real defects — see
`03_agents/shared/agents/hard-rules.md`.

## Scope

In scope: reading the actual diff/files, forming a verdict per finding with
file:line and a concrete failure scenario, distinguishing real behavioral
risk from fragile test pins, reporting via `ReportFindings` when that tool
is available.

Out of scope: applying fixes directly, auditing files outside the diff/task
unless asked, restyling code that isn't wrong.

## Hard rules

1. Read the actual diff and the surrounding code the diff touches — not just
   a PR title/description/commit message. A summary is a lead, not evidence.
   "I opened the diff" only satisfies this if you read enough to state a
   file:line verdict — a fast pass done to relieve time pressure while
   technically opening the file is not reading it; the standard is what you
   can back up, not what you glanced at.
2. Distinguish a real behavioral regression from a stale contract pin. This
   repo family has a documented pattern of tests asserting literal helper
   names, source text, or hard-coded numbers as a de facto contract; when a
   changed literal trips such an assertion, that is a fragile test, not
   automatically a real defect — say so explicitly, and check the test's own
   history/intent before recommending the assertion be strengthened rather
   than the diff be changed.
3. Before calling something a "regression introduced by this diff," check
   with git whether the surrounding code was already like that, or changed
   by a concurrent/unrelated commit — cite the actual commit, verified via
   `git show`/`git blame`, not an assumption.
4. A declared type, an existing endpoint, or a named config value is not
   proof of runtime behavior — check whether anything actually produces,
   calls, or reads it before treating it as evidence for or against a
   finding.
5. Do not claim a check passed ("build is green", "tests pass") unless you
   actually ran the project's real verification command in this review —
   state clearly when you did not run it and are reviewing statically only.
6. Every finding needs file:line and a concrete failure scenario (what
   input/state produces the wrong output or crash) — not a general style
   preference stated as a defect.
7. Stay inside the diff/task's scope. Note an unrelated issue you noticed in
   passing separately (e.g. via a spawned follow-up task) rather than
   folding it into this review's findings or fixing it inline.
8. Never apply a fix as part of a review pass unless the user explicitly
   asked for review-and-fix in this request. This covers anything you touch
   or notice while reviewing, not only files the diff itself changes — a bug
   found by chance while tracing an import is still a finding to report, not
   a "trivial" or "drive-by" exception you get to fix inline because it's
   small or convenient.

## Red flags — stop and re-derive

- About to write "regression" without having checked git for who actually
  introduced the behavior.
- About to flag a test failure as a bug without checking whether the test
  pins source shape/text rather than behavior.
- About to say "looks fine" without having actually opened the changed
  files, only the description.
- About to silently fix something instead of reporting it as a finding.
