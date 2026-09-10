# Task routing — project → knowledge → skills

Read before any meaningful work. Never `Task → edit code`.

## 1. Which project?

| Signal in the task | Project | Repo |
|---|---|---|
| Meta ads, launch, creatives, insights, automation, Page Manager, org/roles, Supabase `ads_launcher`, Vercel, Mac mini, `PAT-`/`BL-`/`TD-` ids | `new-ads-launcher` | `codebases/AdLauncher/` |
| Claude/Codex session logs, tokens, cost, agent analytics, port 4317 | `agent-observatory` | `Projects/Agent-Observatory/` |
| Creative Portal, R2, `creative_portal` schema, Kevin | cross-repo → read `workspace/relationships.md` | AdLauncher side only |
| AI Portal, 9Router, `/staff`, Academy, AI League, `ai.patigroup.com` | `ai-portal` | `codebases/AI-Portal/` |
| Vault structure, notes, ADRs, mistake log | knowledge layer | `Second Brain/` |
| Skills, workspace docs, `.code-workspace` | workspace layer | root |

## 2. Which knowledge?

Order: workspace context → project record → vault → repo docs → code.

1. `workspace/context.md` (always) · `workspace/relationships.md` (if boundary).
2. `workspace/projects/<slug>.md`.
3. Vault for `new-ads-launcher`: `CONTEXT.md` → `PROJECT_INDEX.md` → `src/<feature>/PRD/PRD.md` → `product/backlog.md` / `architecture/tech-debt.md` → `runbooks/`, `integrations/`, `postmortems/`. Use `/pm-vault-knowledge-retrieval` for anything beyond one file.
4. Repo `docs/` for ops facts; then `rg -n "<symbol>" <repo>`.

## 3. Which skills?

Load the **minimum sufficient set**. Two is typical, four is a lot, six is a redesign. Domain READMEs list combos; [`../INDEX.md`](../INDEX.md) has scores.

| Task type | Load (in order) |
|---|---|
| New feature | `build-connected` (calls `grilling` → `domain-modeling` → `vault-system-thinking` → `to-spec` → `to-tickets`) → `writing-plans` → `code-review` → `verification-before-completion` → `vault-note-update` |
| Greenfield / no vault context | `brainstorming` → `writing-plans` → `code-review` → `verification-before-completion` |
| Bug fix | `vault-knowledge-retrieval` → `bug-reproduction-brief` → `systematic-debugging` → `vault-system-thinking` (reverse trace) → `tdd` → `code-review` → `verification-before-completion` |
| Performance | `react-best-practices` + `supabase-postgres-best-practices` → `systematic-debugging` → `analytics-instrumentation` (prove it) |
| UI redesign | `grilling` → `ui-ux-pro-max` → `prototype` → `frontend-design` → `react-best-practices` → `web-design-guidelines` + `accessibility` review |
| Design system / palette / type for a screen | `ui-ux-pro-max` (`python scripts/search.py "<product>" --design-system`) → `frontend-design` |
| Auth / roles / secrets / external integration | `threat-model` → `security-best-practices` → `differential-review` before merge |
| AI / prompt change | `prompt-review` → `agentic-eval` → `llm-cost-optimization` → `threat-model` |
| Decision only | `grilling` or `grill-with-docs` → `domain-modeling`; if not yours → `to-questionnaire` |
| Explain a pasted issue back | `linear-problem-report` |
| Discovery / market | `user-research` / `market-research` / `technical-spike` → `to-spec` |
| Deploy with risk | `rollout-plan` → `verification-before-completion`; if it broke → `incident-postmortem` |
| Docs | `vault-note-update` (existing) / `vault-note-creation` (new); diagrams `html-canvas` · `architecture-diagram` · `bpmn`; Obsidian formats `obsidian-markdown` · `json-canvas` · `obsidian-bases` |
| Status / planning | `daily-app-status` · `update-action-plan` · `wayfinder` · `internal-comms` |
| Editing a skill | `writing-for-agents`, then `pwsh skills/meta/sync-junctions.ps1` + `check.ps1` |
| End of session | `handoff` + one line in `Second Brain/System/mistakes/agent-mistake-log.md` |

## 4. Worked examples

```text
"Fix duplicate creative bug"
Load   vault-knowledge-retrieval → bug-reproduction-brief → systematic-debugging → vault-system-thinking → tdd → code-review → verification-before-completion
Know   src/upload-ads/PRD/PRD.md · CONTEXT.md §creatives.status · architecture/tech-debt.md (TD-30) · lib/duplicate-pipeline.ts, lib/duplicate-naming.ts, lib/import-match.ts
Verify node --test <file> per slice; tsc + test:contract + build once at end
Record BL/TD id if a seam was deferred; mistake-log line if a lesson
```

```text
"Redesign Editor Workspace"
Load   build-connected (gate 1+2) → ui-ux-pro-max → prototype → frontend-design → react-best-practices → web-design-guidelines → accessibility
Skip   security/*, data/* unless gate 2 names a data seam
```

```text
"Ads Manager is slow"
Load   supabase-postgres-best-practices → react-best-practices → systematic-debugging → analytics-instrumentation
Know   architecture/architecture.md · api-map.canvas · Supabase MCP get_advisors / explain
```

## 5. Operating model (12 steps)

1 Identify project · 2 Identify repository · 3 Understand task · 4 Search existing code (whole workspace) · 5 Search project context · 6 Search vault knowledge · 7 Load minimum skills · 8 Check specs / business rules · 9 Analyse impact (Impact Trace) · 10 Implement · 11 Validate · 12 Update docs/knowledge.

## Gaps (after 2026-09-06 curation)

- Prioritisation (RICE/CoD) — vault `product/backlog.md` + global `layer-plan`; no skill.
- Test strategy / regression planning — contract ratchet only.
- SQL / funnel analysis — `supabase-postgres-best-practices` + Supabase MCP; no analytics-query skill.
- Agent design / context engineering — `writing-for-agents` only.
- Sentry-driven debugging — `@sentry/nextjs` installed, `getsentry/sentry-skills` not yet reviewed.
- Ship-readiness tiering — global `ship-gate` (personal), not in this library.
