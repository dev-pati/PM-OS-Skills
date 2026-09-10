---
title: Product Development Framework
status: current
updated: 2026-09-04
tags:
  - framework
  - gates
  - evidence
  - ghost-ads
aliases:
  - PDF
  - product-delivery-control
---

# Product Development Framework

> **Job.** Take a request to **adopted evidence** without losing intent or connections.
> **Audience.** Seth / leader (scan START HERE), PM (gates + adoption), engineer (tracer + verify), future agents (do not skip a gate).
> **Not.** A generic SDLC. This is AdLauncher's control system, distilled from skills actually invoked, mistakes actually logged, and one incident that paid for the residual rules.

Visuals: [[product-development-framework]] canvas (this folder) · rendered HTML at `../../../Outputs/shared/playbooks/product-development-framework.html` (outside the vault — Obsidian cannot open it).

Philosophy stays in [[second-brain-playbook]] (four pillars, Skill→Workflow→Agent→App, Question→Delete→Simplify→Accelerate→Automate last). Skill choice stays in [[skills-index]]. This note is the **delivery spine**.

Canonical gates: [[architecture/decisions/0002-business-and-connection-gates-before-build|ADR-0002]]. Vocabulary: `../../CONTEXT.md`. Sync contract: `../../AGENTS.md`.

---

## START HERE

| | |
|---|---|
| **What shipped 25/07–03/09** | 254 commits `888ba3c` → `2f82696`. feat 93, fix 113. ~242/254 subjects lack a BL/TD id — missing identifier ≠ process violation. |
| **What the vault claimed vs code** | "No CI" was false. Blocking CI exists (`.github/workflows/ci.yml`). Remote-run success **unverified**. |
| **Cron** | Source-wires **13** `call`/`daily_call` lines in `scripts/cron-adlauncher.sh`. Installed crontab unknown — [[architecture/tech-debt#TD-45]]. |
| **IDs** | Canonical **BL-01–BL-88** (62 master-table rows ≠ 88 unique IDs). **TD-01–TD-57**. Next-free unused **BL-89 / TD-58 — do not mint**. |
| **Hard remaining risks** | App Review open (TD-01). No observability (TD-06). No true Meta ad-creation idempotency (TD-53, BL-81). Ghost-ads residual window still exists. |
| **Decision this framework encodes** | Fewer / connected / adopted — in that order. Killing work at Gate 1 is success. |

**Evidence classes — never collapse these:**

| Class | Proves | Does not prove |
|---|---|---|
| Commit reachable from `main` | **Shipped code** | Runtime success, adoption |
| Unique branch commit | Branch-only / unshipped | Abandoned (unless proven) |
| Dirty tree | In-flight only | Ownership, a BL, a commit |
| Runtime / DB / Meta | What actually happened | That the UI told the truth |
| Session chat | What was attempted / decided | That it landed |

`unknown` is load-bearing. Never rewrite it as `failed`, `zero`, or `healthy`.

---

## 1. The spine

```
request → classify evidence → Gate 1 (B1–B9) → Gate 2 (8-plane) → smallest connected spec
      → tracer-bullet tickets → implement → reality verify → ship + propagate docs
      → adoption check → (if broken) incident → correct → prevent
```

Observed in sessions (corpus ~193–195 main-session `.jsonl`, 04/08–03/09/2026 — indexed + deep-read, **not** line-by-line; disclose method, do not headline an exact count):

intake → vault retrieval → business grilling → eight-plane Impact Trace → spec/tickets → TDD/implementation → code review/diagnosis → runtime verification → backlog/docs propagation → mistake/postmortem capture → adoption check.

Skip rules from ADR-0002: genuine one-line bugs skip Gate 1, never Gate 2. Pure typos skip both. A gate that never blocks is paperwork — reopen the ADR.

---

## 2. Intake — classify before acting

1. **Name the request.** Feature, incident, doc correction, ID allocation, or "just a UI change" (highest-risk phrase in this repo).
2. **Name the evidence you have.** Commit / chat / runtime / none.
3. **Name the identifier, or the absence.** No BL id = not chosen ([[product/backlog]]). Do not invent BL-89 / TD-58 / a Tracking module ID / ADR-0007.
4. **Search inbound references** before allocating any stable ID. Collision set BL-71–75 / TD-50 exists because this step was skipped.
5. **Dirty tree is not yours.** Modified/untracked application files stay untouched unless the task is application code.

---

## 3. Gate 1 — Business (B1–B9)

All nine answered **before a spec**. Killing or parking is a successful outcome. Scope that proceeds is the **smallest version**, not the full idea.

| # | Question | Fail closed if |
|---|---|---|
| **B1** | Persona and role — from Overview §4, not "users" | Cannot name who |
| **B2** | Today's workaround and its cost (minutes / errors) | No current pain |
| **B3** | Overview §2 problem or `L-x` limitation + the business consequence already written | Orphan idea |
| **B4** | Which of the eight KPIs moves, direction, rough magnitude | "It will be better" |
| **B5** | Existing `BL-xx` with P&L, or a new Master Backlog row in the same change | Work with no id has been assumed |
| **B6** | Adoption hypothesis — who opens this, how often, inside which **existing** habit | Requires a new habit and does not say so |
| **B7** | Unused signal — how we would find out nobody uses it | Unstated blindness. If the honest answer is "we would not", cite [[product/backlog#BL-12]] and write it down |
| **B8** | Smallest version that proves or kills B6 | Full idea smuggled through |
| **B9** | What happens if we do not build it | "We should anyway" |

Skill: `/build-connected` then `/grilling`. Plane 0 of `/vault-system-thinking` is the same questions; do not answer them twice.

---

## 4. Gate 2 — Connection (eight-plane Impact Trace)

`/vault-system-thinking`. Reverse trace is the step this product's history shows is always missed.

| Plane | Question | Canonical source |
|---|---|---|
| **0 Business** | Gate 1 already passed? Smallest version only | Overview, backlog, this note |
| **1 Process** | Which `W` lane, and which lane next door? | `architecture/bpmn.canvas` |
| **2 Modules** | Forward *and* reverse: every other `M-xx` that names the route/table/`lib/` | [[product/modules]] |
| **3 API** | Every producer of the entity emits the new shape | `architecture/api-map.canvas` + code |
| **4 Data** | Writers, readers, tenancy (`org_id` vs `user_id` — TD-17), RLS, migration. **Every ads-creating path inserts `launch_batches`** | `architecture/data-flow.canvas` |
| **5 External** | Permission, via slot, App Review (TD-01). Request only granted fields; isolate optional ones | Meta Graph v25, postmortems |
| **6 Cross-cutting** | Errors, cache, rate limit, observability (TD-06), testing (TD-12/BL-31/BL-32), flags (none) | Modules §5 |
| **7 Knowledge** | Docs graph closes **in the same change**. Two-way links. Propagation set complete | `AGENTS.md` §4, `/vault-note-update` |

Every row: `Connected` / `Deferred` / `N-A` + reason. **Every deferred seam costs a TD or BL identifier** plus a PRD gap line. Unnamed deferral is how TD-21 happened.

Do not mint the next-free unused ID to satisfy this rule. If no ID is free without a collision search, **leave owner unresolved** and say so.

---

## 5. Smallest connected definition

A change is connected when all of ADR-0002's Definition of Connected holds. Short form:

- Plane 0 filled against the **smallest** version.
- Entry named as feature + `M-xx` + `W` lane.
- Reverse trace done.
- All producers emit the new shape.
- Ads-creating paths journal `launch_batches` **before** the first Meta write (ghost-ads rule).
- Meta permission + via slot named.
- Six cross-cutting answers, including "no".
- Adjacent W-lane checked.
- Docs updated in the same change, two-way.
- Every deferral has an id (or an explicit unresolved-owner note).
- At least one **cross-module** acceptance criterion — "the dialog opens" is not one.

---

## 6. Spec, tickets, tracer bullet

| Step | Skill | Rule |
|---|---|---|
| Spec | `/to-spec`, `/prd-and-technical-documentation-generator` | Cite code or mark NEW. Feature folders are **manual-only**. |
| Tickets | `/to-tickets` | First ticket is the tracer. Blocking edges only. |
| Tracer | `/tdd` then `/implement` | End-to-end and observable **outside the UI**: a row written, a Meta object created, a downstream list updated. With thin CI and no observability, a UI-first slice can look finished while every seam is untouched. |

`ready-for-agent` requires a passed Gate 1.

---

## 7. Reality-based verification

Code beats docs. Runtime beats code. Commit subject proves neither.

| Check | How | Not |
|---|---|---|
| Typecheck / lint / build / contract | **Once**, after the whole change. `npx tsc --noEmit`, `npm run lint`, `npm run build`, **`npm run test:contract`**. Rule: `AGENTS.md` §4, [[mistakes/agent-mistake-log]] | Per-slice tsc. Raw `node --test tests/` is not canonical |
| CI | Blocking workflow exists on `main` | A green **remote** Actions run (unverified as of 04/09) |
| Tests that copy source | Still documentation — TD-12 / BL-32 | Coverage |
| Meta | Field list actually sent, not the TypeScript interface | "the type has `targeting?`" |
| Cron | `scripts/cron-adlauncher.sh` source vs installed crontab | Comments, GitHub workflow |
| Supabase | Schema `ads_launcher` (owned), `creative_portal` (read one table). `public` may be empty shim | Zero rows in `public` |
| Host | Production = Vercel. Mac mini = cron runner, no public ingress | SSH hook failure = deploy failure |
| Interrupted Meta write | `unknown`, not `failed` / `0 created` | Timeout-as-failure |

Do not query or mutate Supabase, SSH, commit, push, or deploy unless the human asked.

---

## 8. Ship + documentation propagation

`/vault-note-update`. One fact → every dependent document, dated `> **Đính chính (DD/MM/YYYY).**` Keep historical AS-IS; overlay current state; never silently rewrite 25–28/07 evidence.

Bound paths (`AGENTS.md` §1–§2): do not rename `product/`, `architecture/`, `reference/handover/`, `src/<feature>/…`. Overwrite the unsuffixed original. Never hand-write `_VerN`. Vault = `.md` / `.canvas` / `.base` / `.mermaid`. Rendered output → `Outputs/<Project>/`. Code → `codebases/AdLauncher/`. Nothing new at workspace root.

---

## 9. Adoption

**Shipped ≠ connected ≠ adopted.** After ship, check B6/B7. "Not adopted" is a finding; removal is a legitimate answer. BL-12 means most unused signals are currently "we would not know" — write that, do not fake a KPI.

---

## 10. Incident → correction → prevention

Worked example: **ghost-ads 25/08/2026** — 27 intended ads became 42 live. Canonical: [[postmortems/2026-08-25-ghost-ads-27-thanh-42]] · [[specs/launch-ghost-ads/impact-trace]].

### What happened (measured)

| Time | Event | Class |
|---|---|---|
| 16:57:34 | Clean failure, zero ads | Runtime |
| 16:59:41–17:00:35 | Invisible partial success, **15 ads** | Runtime — UI said failed/zero |
| 17:15:26 | Mitigation deploy `b4ceb34` (`maxDuration` 60→300, chunk 20→10) | Shipped code — **not** a root-cause fix |
| 17:21:51 | Relaunch success, 27 ads | Runtime |
| Total | **42 ads** | Buyer relaunched all 27 because unknown was classified as failed |

### Structural ordering (the rule the incident bought)

1. Open `launch_batches` with `in_flight` **before** the first Meta write.
2. Journal each Meta ad ID as soon as Meta returns it.
3. Interrupted request stays `unknown`.
4. Retry only rows **proven absent**.
5. Residual window remains between Meta response and journal write.
6. Meta has **no** true ad-creation idempotency key for this flow.
7. Automatic Meta reconciliation is unbuilt ([[product/backlog#BL-81]], TD-53, TD-54).

Timeout/chunk tuning is mitigation. Calling it the root-cause fix is the mistake the log exists to stop.

### Prevention controls now in the spine

- Ads-creating path without a pre-write `launch_batches` row = Gate 2 fail.
- UI must render `unknown` as unknown, never as `0 created`.
- Contract tests: `unknown` transition + batch-id-before-first-write. Runner: `npm run test:contract`.
- Do not relaunch a batch whose journal is missing — reconcile first (BL-81, unbuilt).

---

## 11. Skills actually used (measured)

Corpus-wide skill invocations in the 04/08–03/09 window: **254 invocations, 40 distinct names**. Highest:

| Skill | n | Role on this spine |
|---|---|---|
| `codebase-memory` | 40 | Graph search before grep |
| `vault-system-thinking` | 31 | Gate 2 |
| `vault-knowledge-retrieval` | 23 | Intake grounding |
| `build-connected` | 17 | Both gates |
| `grilling` | 16 | Gate 1 |
| `diagnosing-bugs` | 15 | Incident |
| `artifact-design` | 15 | Rendered output |
| `code-review` | 14 | Verify |
| `ui-ux-pro-max` | 7 | Surface |
| `update-action-plan` | 6 | Comms, not delivery |
| `plan` | 6 | Tickets |
| `lark-action-plan` | 6 | Comms |
| `html-canvas` | 5 | Stakeholder scan |
| `dataviz` | 5 | Evidence |
| `tdd` | 4 | Tracer |

`/archify` was **observed and missing** from [[skills-index]] until 04/09. Index now lists it. Do not treat Skills Index as the invocation log — the log is the corpus; the index is the menu.

---

## 12. Repeated failure patterns → remediation → control

| Pattern (paid for) | Remediation that worked | Standing control |
|---|---|---|
| Trust TypeScript instead of Meta field lists | Read the Graph `fields=` list; patch every producer | Plane 5 + "type ≠ payload" in CONTEXT |
| Trust endpoint existence instead of callers | Grep importers before deleting/rewiring | Reverse trace, plane 2–3 |
| Trust comments/config instead of execution | Read `cron-adlauncher.sh`; do not cite GitHub workflow as scheduler | Source vs installed vs live (TD-45) |
| Weaken fallback before replacement renders | Keep legacy path until the new one is proven | Gate 2 data plane |
| Wrong test runner | `npm run test:contract` | This note §7 |
| Tests that copy source | Import the real module | TD-12 / BL-32, not "CI exists" |
| Not rejecting `indexOf() === -1` | Fail closed on missing allowlist match | SSRF TD-24 pattern |
| Stale worktree patch deletes dirty-parent work | Patch against **current parent**; `git apply --check` | Mistake log 2026-08-30 |
| Read Mac-mini SSH hook as Vercel deploy status | Production is Vercel | `CONTEXT.md` hosting paragraph |
| Query wrong Supabase schema | `ads_launcher` owned; `public` may be empty | Boundary ADR-0003 |
| Add a column before migration without `42703` fallback | Catch 42703, retry legacy projection | Migrations locked |
| One optional Meta field crashes the flow | Isolate permission-dependent fields | Plane 5 |
| Shrink diagram typography instead of fixing layout/viewBox | Do not set `viewBox` initially; consume Archify diagnostics | `/archify` authoring contract |
| Treat timeout as failure | `unknown` | Ghost-ads §10 |
| Call timeout/chunk tuning a root-cause fix | Name the journal-before-write bug | BL-81 / TD-53 |
| Allocate stable IDs before global inbound-reference search | Search all inbound refs; collision note; do not mint | This overlay; next-free unused BL-89/TD-58 |
| Missing query output treated as absence | Re-query; zero output from a bad glob is not evidence | Mistake log 04/09 |
| Mid-task compact | Finish the task first | Feedback memory |

---

## 13. Chat behaviour this framework assumes

- Vietnamese request → Vietnamese scan for Seth; English IDs, paths, commands stay verbatim.
- Interrupt ≠ cancel. Compaction ≠ new brief.
- Subagent worktree isolation fails at this workspace root (git lives under `codebases/AdLauncher/`). Do not retry.
- `notify_when_idle` is not how you wait on a subagent.
- Transcript access may be refused; corpus index + deep read is the honest method — say so.
- Do not SSH, Tailscale, ping, or query Supabase without an explicit ask.
- Deploy blackout 13:00–15:00 UTC+7 for blocking ad-control scope.
- Verify once at the end, not per slice.

---

## 14. 04/09 overlay — what this pass did and did not do

**Did.** Dated overlays on backlog, tech-debt, modules, roadmap, `CONTEXT.md`, `README.md`, INDEX, skills-index, playbook, ghost-ads impact-trace. Collision registry preserved canonical owners; direct-corrected only proven aliases (Create Surface historical BL-73 → BL-74; external-ad D3 TD-50 → TD-45). Daily Report recorded as shipped-code evidence **without** a BL. Framework + canvas + Archify artifacts added.

**Did not.** Mint BL-89, TD-58, ADR-0007, or a Tracking module ID. Edit application code. Query/mutate Supabase. Commit, push, deploy, SSH. Claim remote CI green. Claim crontab live. Reassign unresolved owners (editor-close, external-ad/webhook BL, Daily Report BL). Touch the dirty application tree.

Unresolved owners stay unresolved until a human allocates an identifier after a global inbound-reference search.

---

## Links (two-way)

- Gates: [[architecture/decisions/0002-business-and-connection-gates-before-build]]
- Backlog + collision registry: [[product/backlog]]
- Debt: [[architecture/tech-debt]]
- Modules: [[product/modules]]
- Ghost-ads: [[postmortems/2026-08-25-ghost-ads-27-thanh-42]] · [[specs/launch-ghost-ads/impact-trace]]
- Skills: [[skills-index]]
- Playbook: [[second-brain-playbook]]
- Mistakes: [[mistakes/agent-mistake-log]]
- Home: [[CLAUDE]]

## Visual: PM workflow diagram

Sơ đồ 10 stage của framework này, dark-theme self-contained HTML:
`Second Brain/Outputs/shared/playbooks/pm-workflow.html`

Dựng bằng `/architecture-diagram` từ chính note này (§1 spine, §2 intake, §3 Gate 1, §4 Gate 2, §5–§10). Có toolbar export Copy / PNG / PDF. Màu theo semantic của skill: hồng = gate và incident, lam = định nghĩa, lục = build/ship, tím = verify/vault, cam = adoption.

Mở lại sau khi sửa framework — file là output tái tạo được, không phải nguồn.


## Full operating loop

Framework này là **Phase A** của một vòng lớn hơn: [[pm-operating-system]] ghép nó với Linear issue feedback loop (delivery) và adoption/learning.

Sơ đồ đầy đủ ba phase: `Second Brain/Outputs/shared/playbooks/pm-operating-system.html`

