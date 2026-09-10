# meta/

Purpose: the library about the library.

| File | What |
|---|---|
| `writing-for-agents/` | Skill for writing/editing skills, AGENTS.md, CLAUDE.md. Load before touching any SKILL.md. |
| `task-routing.md` | Task → project → knowledge → minimum skill set. Read at session start. |
| `sync-junctions.ps1` | Rebuild `_flat/` and re-link every consumer's `.claude/skills` + `.agents/skills` after adding/removing a skill. |
| `check.ps1` | Library invariants: cap 10/domain, README per domain, name = folder, unique names, junction layers complete, INDEX coverage, refs resolve. Exit code = error count. |

Quality gate and cap (10/domain): [`../README.md`](../README.md).
