---
name: vault-knowledge-retrieval
description: Search and synthesise knowledge from this vault — the AS-IS document set (product/ and architecture/), per-feature specs under src/<feature>/, runbooks, reference material and incident post-mortems. Use when asked what the product does, how a module works, what depends on what, what is broken, what a TD/BL/M/W/S identifier refers to, or when you need grounded context before doing any other task. Answers only from vault files, always cited, and flags where the vault is stale against the code.
---

# Vault Knowledge Retrieval

Retrieve and synthesise from this vault. This is the grounding step for every other skill — [[vault-note-creation]], [[vault-note-update]], and [[vault-system-thinking]] all begin here.

The vault is **not** a PARA vault. It is a product knowledge graph, organised into layers with stable identifiers. Learn the layers before searching.

This vault is multi-project: `Second Brain/projects/<project>/` holds one project's tree. Every path in the table below is relative to the active project's root — today that means `Second Brain/Projects/AdLauncher/product/` etc. Figure out which project the task belongs to before searching. The one exception is `reference/agents/` (issue tracker, triage labels), which is shared across projects at `Second Brain/System/agents/` regardless of which project you're in.

---

## The layers

| Layer | Path | What lives there | Authority |
|---|---|---|---|
| **AS-IS set** | `product/` + `architecture/` | The eight canonical documents + three `.canvas` diagrams. Basis commit `888ba3c` (25 Jul 2026). `product/` is the PM view (overview, audit, modules, backlog, roadmap); `architecture/` the engineering view (architecture, tech debt, canvases, `decisions/`) | **Source of truth for documentation.** Start here |
| **Feature specs** | `src/<feature>/{PRD,BPMN,API,DATAFLOW}/` | 21 features, each with PRD, BPMN mermaid, API contract, data flow. Conventions in `AGENTS.md` | Feature-level detail; may lag the AS-IS set |
| **In-flight specs** | `specs/<slug>/` | PRD + tech plan for work that has no `src/` feature folder yet | Design intent, may be unbuilt |
| **Runbooks** | `runbooks/` | Deploy, Mac mini, Cloudflare tunnel — procedures, not description | Operational, kept deliberately |
| **Reference** | `reference/` | Onboarding, ad-format guide, handover record, SQL scripts, `agents/domain.md`. `reference/agents/issue-tracker.md` and `triage-labels.md` are **shared**, not per-project — always at `Second Brain/System/agents/` | Reference material |
| **Incidents** | `postmortems/` | Real failures with real root causes, dated | High value, rarely stale |
| **Tech plans / sub-PRDs** | `src/<feature>/PRD/<Topic>.md`, `src/<feature>/API/*TechPlan.md` | Scoped designs (e.g. Page Manager Comment-Ops, Inbox-Ops, Realtime) | Design intent, may be unbuilt |
| **Handoffs** | `integrations/` | Creative Portal / R2 / shared-Supabase boundary material, infra canvases | Active integration context |
| **Feedback** | `feedback/` | Captured user feedback items | Raw signal |
| **Meta submission** | `submissions/`, `src/page-manager/APP-REVIEW-META-PERMISSIONS.md` | App Review assets and permission mapping | Compliance context |
| **Superseded** | *(none — removed 28 Jul 2026)* | The `_superseded-072826/` and `_archive/` quarantine folders were deleted once the AS-IS set was confirmed to cover them | There is no quarantine layer. Do not search for one |
| **Code** | `codebases/AdLauncher/` (per-project — the app repo for the project you're in) | The application | **Outranks every document above** |

## Stable identifiers

Learn to resolve these directly — a query mentioning one is a lookup, not a search:

| Prefix | Range | Meaning | Home |
|---|---|---|---|
| `TD-` | 01–28 | Technical debt item | `architecture/tech-debt.md` |
| `S` | 1–8 | Security finding | `architecture/tech-debt.md` |
| `BL-` | 01–36 | Backlog item with P&L score | `product/backlog.md` |
| `M-` | 01–20 | Module | `product/modules.md` |
| `W` | 1–13 | BPMN process / lane | `architecture/bpmn.canvas` |

Never renumber them. The `.canvas` files are [JSON Canvas 1.0](https://jsoncanvas.org/) — plain JSON, searchable with text search, readable with Read.

---

## Instructions

1. **Classify the query.**
   - **Identifier lookup** (`TD-21`, `BL-16`, `M-07`, `W5`) → go straight to that document's section.
   - **Module / feature question** ("how does Launch work") → Modules Inventory entry, then `src/<feature>/PRD/PRD.md`, then the canvases.
   - **Dependency question** ("what depends on `launch_batches`", "what breaks if I change this route") → this is an impact question; retrieve, then hand off to [[vault-system-thinking]].
   - **Breakage / risk question** → Technical Debt, then `postmortems/`.
   - **Value / sequencing question** → Master Backlog (sorted by P&L) and Short-term Roadmap. They disagree on purpose — the Backlog says what is worth most, the Roadmap says what happens next.
   - **Historical question** ("what did we used to do", "why was this changed") → Product Audit, then `architecture/decisions/`. The vault keeps no quarantine folder; for code history use `git log` in `codebases/AdLauncher/`.
   - **Operational question** (deploy, env, host) → `runbooks/`, `integrations/`.

2. **Locate files.** Glob by layer (`product/*.md`, `architecture/*.md`, `src/**/PRD/*.md`, `postmortems/*.md`) and grep for keywords across body text, table cells, and canvas JSON. For a broad topic, sweep all layers — a question about video upload hits `architecture/tech-debt.md` (TD-22), `src/upload-ads/`, `src/assets/`, `postmortems/`, and `product/backlog.md`.

3. **Read before answering.** Read the matching sections in full. Table-heavy documents lose their meaning when skimmed — the `Dependencies` and `Known issues` rows of a module entry are usually the answer.

4. **Trace connections.** Do not stop at the first match. Follow the graph:
   - Module entry → its `Related APIs`, `Related tables`, `Related services`, `Dependencies`.
   - Any `TD-`/`BL-` reference inside a document → resolve it and say what it is.
   - Feature PRD → the AS-IS document that supersedes or corrects it.
   - A finding in one module → grep the Modules Inventory for the same route/table to find the *other* modules that share it.

5. **Synthesise.** Lead with the direct answer in one or two sentences. Then supporting detail, ordered: AS-IS → feature spec → project docs → incidents. Connect the dots explicitly; a list of files is not an answer.

6. **Report staleness and gaps** — this is part of the answer, not an appendix:
   - A feature PRD whose claim is contradicted by an AS-IS document or by the code → say so and cite both. (`src/launch/PRD/PRD.md` §3 is the worked example of this.)
   - An unverified-since banner in a doc → surface it.
   - A module with no PRD content, a feature with an empty DATAFLOW, a TD item with no owner → name the gap.
   - Any figure that looks retyped rather than generated → flag it against [BL-34](product/backlog.md#bl-34--documentation-freshness-automation).

---

## Guidelines

- **Vault-only sourcing.** Answer from vault files. Do not fill gaps from general knowledge or from memory of earlier sessions. If the vault does not cover it, say so plainly and name where it would belong.
- **Cite everything**, with the path: `[architecture/tech-debt.md#td-21]`, `[src/launch/PRD/PRD.md §6]`, `[postmortems/2026-07-14-mto-text-variations-fix.md]`.
- **Code wins.** If the answer matters and the documents are old, read `codebases/AdLauncher/` and report the discrepancy as a finding.
- **There is no superseded/archive layer.** Both quarantine folders were deleted on 28 Jul 2026. If a document points into `_superseded-072826/` or `_archive/`, that link is dead — report it as a finding, do not go looking for the folder.
- **Preserve the vault's terminology**, including the Vietnamese phrasing in feature PRDs and the canonical glossary in Product Overview §13. Do not silently re-translate a term.
- **Counts are as-of `888ba3c`** (207 routes, ~59 tables, 49 migrations, 70 Graph call sites, 0 CI pipelines). Quote them with that caveat.
- **Do not answer a dependency question with a retrieval.** If the user is about to change something, retrieval is step one of [[vault-system-thinking]] — say so and continue into it.

---

*Adapted for this vault from [jamesmcroft/obsidian-ai-second-brain](https://github.com/jamesmcroft/obsidian-ai-second-brain) (MIT). Upstream targets a PARA vault (Areas / Techniques / Resources); this version targets the AS-IS + `src/<feature>/` product docs graph and its stable identifiers.*
