# superpowers/

obra/superpowers vendored whole (14 skills, MIT, 282k★) — the one complete dev methodology, kept together so its internal cross-refs hold. Exempt from the 10/domain cap by design; do not add non-superpowers skills here.

| Skill | Load when |
|---|---|
| `using-superpowers` | Session bootstrap: how to find and invoke the others. |
| `brainstorming` | Before any creative work; refines intent, presents design in sections. Overlaps `product/grilling` — prefer `grilling` inside `build-connected`, `brainstorming` for greenfield/no-vault work. |
| `writing-plans` | Approved design → bite-sized tasks with file paths and verification. |
| `executing-plans` | Run a written plan in a separate session with checkpoints. |
| `subagent-driven-development` | Fresh subagent per task, two-stage review. |
| `dispatching-parallel-agents` | Independent tasks, parallel agents. |
| `test-driven-development` | RED-GREEN-REFACTOR; deletes code written before tests. `engineering/tdd` is the lighter mattpocock variant. |
| `systematic-debugging` | Anything broken/failing/slow — root cause before fixes. |
| `verification-before-completion` | No "done" claim without running the check and reading output. |
| `requesting-code-review` / `receiving-code-review` | Ask for review; act on review without over-agreeing. |
| `using-git-worktrees` | Isolated branch workspace for a task (`codebases/AdLauncher/` only). |
| `finishing-a-development-branch` | Merge / PR / keep / discard + cleanup. |
| `writing-skills` | Authoring/testing skills. `meta/writing-for-agents` is the mattpocock counterpart. |

Workflow: `brainstorming` → `using-git-worktrees` → `writing-plans` → `subagent-driven-development` or `executing-plans` → `test-driven-development` → `requesting-code-review` → `finishing-a-development-branch`. Here, `product/build-connected` remains the front door; superpowers plugs in from `writing-plans` onward.