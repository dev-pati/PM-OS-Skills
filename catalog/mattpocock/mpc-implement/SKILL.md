---
name: mpc-implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
source:
  repo: https://github.com/mattpocock/skills
  path: skills/engineering/implement
  commit: 959a8e9
  license: MIT
  fetched: 2026-09-17
  adapted: true
  upstream_name: implement
---

Implement the work described by the user in the spec or tickets.

Use /mpc-tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /mpc-code-review to review the work.

Commit your work to the current branch.
