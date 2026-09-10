---
name: pm-vault-system-thinking
description: Trace a change across every plane of the system before it is called done — business (persona, KPI, adoption), process (W-lanes), modules (M-ids), APIs, data/tables, external contracts, cross-cutting concerns, and the docs graph. Use BEFORE building or documenting any feature change, and whenever a change looks UI-only, touches more than one module, or when asked "what else does this affect", "why is this disconnected", "do an impact analysis". Produces a mandatory Impact Trace and forces every unconnected seam to become a tracked TD/BL item instead of silent debt.
---

# Vault System Thinking — Impact Tracing

This vault documents a product where the recurring failure is not bad code. It is **features that land at the surface**: a screen ships, a route works, a doc gets a new section — and the seams to everything else are never traced. The vault already records the cost of that pattern:

- [TD-21](architecture/tech-debt.md#td-21--campaign-creation-is-disconnected-from-launch) — campaign creation and Launch both work, and **share no state, preset, or naming schema**.
- [TD-14](architecture/tech-debt.md) — documentation contradicts the code, because docs were updated in a different change than the code.
- `README.md` §"What that produced" — an entire document set was rewritten because a PRD statement was true when written and never re-traced.
- [BL-12](product/backlog.md) — none of the eight product KPIs are instrumented, so a feature nobody opens looks identical to a feature everybody depends on.

That last one is why this skill starts at the **business plane** rather than at the code. A change can be perfectly connected to every module in the system and still be worth nothing.

This skill exists so that class of outcome stops being produced. It is a **gate**, not a report: a change is not done until its Impact Trace is complete and every deferred seam is a tracked identifier.

This vault is multi-project: every path below (`product/`, `architecture/`, `src/`, `postmortems/`, etc.) is relative to the active project's root, `Second Brain/projects/<project>/` — today that means `Second Brain/Projects/AdLauncher/`. Confirm which project the change belongs to before tracing.

---

## When this skill is mandatory

Invoke it before you write code or docs, whenever any of these is true:

| Trigger | Why |
|---|---|
| A new feature, screen, dialog, or field | New surface always creates new seams |
| A feature nobody has named a persona or KPI for | Plane 0 catches this before the other seven cost anything |
| A change to any `src/<feature>/PRD`, `API`, `DATAFLOW`, `BPMN` doc | The doc set is a graph; editing one node without its edges is how TD-14 happens |
| A change that writes or reads a database table | Every table has more than one reader in this product |
| A change to any `/api/facebook/*` route | The Meta contract is shared by 70 call sites |
| A change to auth, org scoping, roles, or tokens | 6 RLS roles, inconsistent `user_id` vs `org_id` (TD-17) |
| "Just a UI change" / "just a small addition" | This is the highest-risk phrasing in this repo |
| The user asks why two features do not talk to each other | The answer is a trace, not a guess |

Skip it only for pure typo fixes and for work that touches exactly one file with no callers.

---

## Ground truth — read these, do not recall them

The vault's source of truth is the **AS-IS set**, basis commit `888ba3c` (25 Jul 2026). Read the relevant ones each time; they change.

| Plane | Source of truth |
|---|---|
| Business | [`product/overview.md`](product/overview.md) — §2 problems solved, §4 personas, §10 limitations **L1–L9** with their business consequence, §11 the eight KPIs · `feedback/` for what users actually said |
| Process | [`architecture/bpmn.canvas`](architecture/bpmn.canvas) — 13 processes **W1–W13**, 187 nodes |
| Modules | [`product/modules.md`](product/modules.md) — **M-01–M-20**, each with `Related APIs`, `Related tables`, `Related services`, `Dependencies`, `Known issues` |
| API | [`architecture/api-map.canvas`](architecture/api-map.canvas) — 207 routes in 9 groups, producer/consumer edges |
| Data | [`architecture/data-flow.canvas`](architecture/data-flow.canvas) — 8 layers, ~59 tables in `ads_launcher` |
| Architecture & boundaries | [`architecture/architecture.md`](architecture/architecture.md) |
| Known breakage | [`architecture/tech-debt.md`](architecture/tech-debt.md) — TD-01–TD-28, S1–S8 |
| Value & sequencing | [`product/backlog.md`](product/backlog.md) (BL-01–BL-36) · [`Short-term Roadmap`](product/roadmap.md) |
| Feature-level spec | `src/<feature>/{PRD,API,DATAFLOW,BPMN}/` — conventions in [`AGENTS.md`](../../../AGENTS.md) |
| Incident history | `postmortems/` — real failures with real root causes |
| Code | `codebases/AdLauncher/` — **outranks every document above when they disagree** |

Identifiers **TD-**, **BL-**, **S**, **M-**, **W** are stable. Never renumber them. Cite them; do not invent new ones outside the ranges without saying so.

---

## The eight planes

A change is connected when it has been traced on all eight. Most surface-level work traces plane 1 and stops.

### 0. Business plane — whose problem, which KPI, will it be used
Trace this **first**, and stop here if it does not hold. The other seven planes are about whether a feature works; this one is about whether it should exist.

- **Persona and role.** Who, from Product Overview §4 and the role model in §5. Not "users".
- **The problem, and today's workaround.** Map it to a §2 problem or to an `L`-numbered limitation *and the business consequence that limitation already states*. Describe what the person does today instead, with its cost in minutes or errors — that number is the value ceiling of the whole change.
- **The KPI line.** Which of the eight in §11 moves, in which direction, by roughly how much.
- **The BL id.** An existing `BL-xx`, or a new Master Backlog entry with a P&L score written in this same change. Work with no backlog id has not been chosen; it has been assumed.
- **The adoption hypothesis.** Who opens this, how often, and inside which habit they already have. A feature that requires a new habit needs to say so — that is the main reason things go unused here.
- **The unused signal.** How you would find out nobody uses it. With zero instrumentation (BL-12) the honest answer is often "we would not" — write that down and cite BL-12. Stated blindness is a finding; unstated blindness is how dead features accumulate.
- **The smallest version.** The thinnest slice that would prove or kill the adoption hypothesis. Trace the remaining seven planes against *that*, not against the full idea.

If a request cannot fill these in, the finding to report is the gap, not a plan. Run `/pm-build-connected` for the full gate, or `/grill-me` to work the answers out with the user.

### 1. Process plane — which W-lane, and which lane *next door*
Locate the change in `BPMN.canvas` (W1–W13). Then ask the question that gets skipped: **which adjacent lane hands work to this one, or receives work from it?** W5 · Launch and W13 · Campaign Creation are the canonical example of two lanes that were never connected.

### 2. Module plane — forward *and reverse*
Read the module entry (M-xx) for the module you are changing: its `Related APIs`, `Related tables`, `Related services`, `Dependencies`.

Then do the **reverse lookup**, which is the step this product's history shows is always missed: grep the Modules Inventory for the API route, table, or `lib/` file you are touching and list *every other* M-id that names it. If `launch_batches` appears under M-01 and M-03, an insert-shape change in Launch is an Insights change.

### 3. API plane — producer and consumer
For each route you add or change, establish from `API Map.canvas` and from the code: who calls it, what shape it returns, whether another route returns the same entity in a different shape. A new field on a response is not delivered until every producer of that entity emits it — otherwise the UI renders `undefined` for some paths and nobody notices.

### 4. Data plane — writers, readers, tenancy, migration
For each table: who writes it, who reads it, is it scoped by `org_id` or `user_id` (TD-17 — they are inconsistent), which of the 6 RLS roles can see it, does a migration accompany the change, and does anything cached in `meta_api_cache` become stale. Mandatory product rule: **every ads-creating path must insert `launch_batches`** (`src/launch/PRD/PRD.md` §6 — a route once shipped without it).

### 5. External-contract plane — Meta, and the other integrations
Meta Graph v25 (with v21/v22 stragglers — TD-11). For any Meta-touching change: which **permission scope** does it need (`ads_management`, `pages_show_list`, `business_management`, …), which **token slot / via-connection** supplies it, and does App Review cover it (TD-01 — it does not yet). Field-level interactions matter: see `postmortems/2026-07-14-mto-text-variations-fix.md` for a case where sending one extra spec field silently converted the ad set to a different product behaviour. Also in scope: Creative Portal / R2, Google Drive/Sheets, OpenAI/Gemini per-org keys.

### 6. Cross-cutting plane — the six concerns from §5 of the Modules Inventory
Every one of these has a documented gap, so every new feature either inherits the gap or widens it. Answer explicitly:

- **Errors** — normalised through `lib/meta-error.ts`? surfaced to the user? persisted anywhere?
- **Caching** — what goes stale, and what invalidates it? (No invalidation strategy exists.)
- **Rate limiting** — does this add Meta calls to a hot path? (`lib/rate-limit-store.ts` tracks headroom.)
- **Observability** — how would you know this broke in production? (Today: you would not — TD-06.)
- **Testing** — what assertion proves this works, and does anything execute it? (No CI — TD-12.)
- **Feature flags** — none exist, so this ships to everyone at once. Is that acceptable?

### 7. Knowledge plane — the docs graph closes in the same change
Per `README.md`: *"When you change the code, update the affected document in the same change."* Per `AGENTS.md` §4: overwrite the original file in the correct kind subfolder, never hand-write `_VerN` snapshots, never auto-create feature folders. A change that leaves its PRD stale has produced TD-14 again.

---

## Procedure

1. **Anchor.** Plane 0 first: persona, problem, KPI, BL id, adoption hypothesis, smallest version. Then the system entry point: feature folder, M-id, W-lane. If you cannot name all of these, read until you can — and if plane 0 stays empty, report that instead of tracing the rest.
2. **Forward trace.** Planes 2–5, downstream: what does this change reach?
3. **Reverse trace.** Planes 2–4, upstream: what reaches *into* the things this change alters? Grep the Modules Inventory and the code for every route, table, and `lib/` file you touch. **Do not skip this step. It is the whole point of this skill.**
4. **Seam check.** Walk [`references/seam-registry.md`](references/seam-registry.md) — the recurring seams in this product, with the evidence for each. **Section F (business and adoption) first**; it is the only section that can stop the change. Mark each row hit / not hit.
5. **Build the Impact Trace.** Use [`references/impact-trace-template.md`](references/impact-trace-template.md). Every row is `Connected` / `Deferred` / `N-A`, with a reason. No blanks.
6. **Resolve the Deferred rows — deferral costs an identifier.** For each seam you are not connecting now, do one of:
   - add it to the feature PRD's gap/status table as a named gap, **and**
   - open a **TD** entry in `architecture/tech-debt.md` if it is risk/breakage, or a **BL** entry in `product/backlog.md` if it is unbuilt value — following the existing entry format and scoring columns, next free number in the range.
   - If neither is warranted, say so in one sentence and why. "We'll do it later" with no identifier is the exact behaviour this skill removes.
7. **Close the docs graph.** Update the affected `src/<feature>/{PRD,API,DATAFLOW,BPMN}` files and any AS-IS document, in this same change, per `AGENTS.md` §4. Add cross-references both ways — the other module's doc should point back.
8. **Make it verifiable.** Add at least one acceptance criterion that asserts a *cross-module* outcome, not a UI outcome. "The dialog opens" is not one. "Launching from Table mode writes `launch_batches` with the correct `org_id`, and the row appears in launch history" is one.
9. **Report.** Impact Trace table, then: connected seams, deferred seams with their new TD/BL ids, documents updated, and the residual risk you are knowingly accepting.

---

## Definition of Connected

Do not report a change as done until all of these hold:

- [ ] Plane 0 answered: persona, problem + today's workaround, KPI line, BL id, adoption hypothesis, unused signal, smallest version.
- [ ] Entry point named as feature + M-id + W-lane.
- [ ] Reverse trace done: every other M-id that shares the routes/tables/services touched is listed.
- [ ] Every changed response shape is emitted by **all** producers of that entity, not just the new path.
- [ ] Table changes state their writers, readers, tenancy column, and RLS roles; any ads-creating path inserts `launch_batches`.
- [ ] Meta changes state the permission scope, the token/via slot, and App Review status.
- [ ] All six cross-cutting concerns answered explicitly, including "no" answers.
- [ ] Adjacent W-lane checked for a handoff that should exist.
- [ ] Affected `src/<feature>/` docs and AS-IS documents updated **in this change**, with two-way cross-links.
- [ ] Every deferred seam carries a TD or BL identifier and a PRD gap line.
- [ ] At least one cross-module acceptance criterion written.

---

## Guidelines

- **Plane 0 outranks the rest.** A well-connected feature nobody needs is a more expensive mistake than a disconnected one, because it looks like success. Trace the business plane before you spend effort on the other seven.
- **Fewer, connected, adopted** — in that order. Feature count is not a measure of progress in this product.
- **Code outranks docs.** When the AS-IS set and `codebases/AdLauncher/` disagree, the code is right and the document is a finding — record it.
- **Trace before you design.** Running this after implementation produces a justification, not an analysis.
- **Reverse trace is not optional.** Forward tracing finds what you already knew you were touching.
- **Name the seam you are leaving open.** An unnamed seam becomes TD-21. A named seam becomes a backlog item with a P&L estimate.
- **Two-way links only.** If module A's doc now references B, B's doc references A. One-directional links rot silently.
- **Do not renumber TD / BL / S / M / W identifiers**, and do not silently reuse a retired one.
- **Cite file paths** for every claim, e.g. `[architecture/tech-debt.md#td-21]`, `[src/launch/PRD/PRD.md §6]`.
- **Prefer a small connected change over a large surface change.** Shipping half a feature with its seams traced is better than shipping all of it with none.
- **Report deferrals plainly.** The user decides what to fund; your job is to make the cost visible, not to hide it or to refuse the work.

---

*Adapted for this vault from the `vault-*` skill family in [jamesmcroft/obsidian-ai-second-brain](https://github.com/jamesmcroft/obsidian-ai-second-brain) (MIT). Upstream provides Capture/Organize/Distill over a PARA vault; this skill is the addition that vault does not have — an interconnection gate for a product docs graph.*
