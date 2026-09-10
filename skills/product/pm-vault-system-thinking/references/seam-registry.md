# Seam Registry

The seams in this product that get skipped, each with the evidence that it was skipped before. Walk every row during step 4 of `vault-system-thinking`. Mark **hit** / **not hit**; a hit row must appear in the Impact Trace.

Add a row whenever a new disconnection is found in the wild. Keep the evidence column pointing at a real file — a seam without evidence is speculation and belongs in a TD entry instead.

This registry is AdLauncher-specific: every evidence path below (`architecture/tech-debt.md`, `src/launch/PRD/PRD.md`, etc.) is relative to `Second Brain/Projects/AdLauncher/`.

**Walk section F first.** A–E ask whether a change works; F asks whether it is worth building. F is the only section that can stop the change outright.

---

## A · Structure and state seams

| # | Seam | The question to ask | Evidence it has been missed |
|---|---|---|---|
| A1 | Launch ⟷ Campaign Creation | Does the new state (preset, naming, ad-set config) exist on **both** paths, or only the one I touched? | [TD-21](architecture/tech-debt.md#td-21--campaign-creation-is-disconnected-from-launch); `src/launch/PRD/PRD.md` §3 correction (25/07/2026) |
| A2 | Naming schema application | Does the generated name flow into this path, or does the user retype it? | M-09 · Templates & Naming; `src/launch/PRD/PRD.md` §7 "Naming schema auto-apply (T9) — chưa tích hợp" |
| A3 | Presets reachability | Is the preset readable from every launch surface, or only from `/presets`? | M-12 · Presets is **not in the sidebar**, URL-only (Modules Inventory §2) |
| A4 | Inspo → Launch input | Does creative/insight output actually become launch input? | `src/launch/PRD/PRD.md` §7 "input từ Inspo (T8) — chưa tích hợp" |
| A5 | Draft ⟷ scheduled activation | Does state saved in one place survive the other path? | `launch_drafts`, `scheduled_activations` both owned by M-01 |
| A6 | Gallery mode ⟷ Table mode | Was the change made in both modes of the same screen? | `launch/page.tsx` is 16,522 lines — one mode is routinely edited alone (TD-07) |

## B · Data seams

| # | Seam | The question to ask | Evidence it has been missed |
|---|---|---|---|
| B1 | `launch_batches` insert | Does **every** ads-creating path record the batch? | `src/launch/PRD/PRD.md` §6: "route cũ từng thiếu" (ERROR_LOG 08/06) |
| B2 | Tenancy column | Is this scoped by `org_id` or `user_id`, and does that match its neighbours? | [TD-17](architecture/tech-debt.md) — tenant scoping inconsistent across tables |
| B3 | RLS role coverage | Which of the 6 roles can read/write this, and was the policy shipped with the migration? | Architecture doc, RLS roles = 6 |
| B4 | Cache staleness | What in `meta_api_cache` or a TTL env var now returns stale data? | Modules Inventory §5: "No cache invalidation strategy documented" |
| B5 | Second reader of a table | Who else selects this table, and does the shape change break them? | `launch_batches` read by M-01 *and* M-03 Insights |
| B6 | Migration accompanies the change | Is there a migration, and is it in the shared Supabase project's locked set? | 49 migrations; shared project `vrnstjkxumaaduqswkji` |

## C · API and contract seams

| # | Seam | The question to ask | Evidence it has been missed |
|---|---|---|---|
| C1 | All producers of an entity | Does every route returning this entity return the new field? | 207 routes; `launch`, `launch-direct`, `launch-table-batch` all create ads |
| C2 | Meta permission scope | Which scope does this need, and is it in the App Review submission? | [TD-01](architecture/tech-debt.md) — App Review not passed; `src/page-manager/APP-REVIEW-META-PERMISSIONS.md` |
| C3 | Token / via slot | Which via-connection or OAuth token supplies this call, and what happens when it is absent? | `lib/via-connections.ts`; M-01 `Dependencies`: "a valid **via LAUNCH** token" |
| C4 | Graph API version | Does this call site match v25, or add another v21/v22 straggler? | [TD-11](architecture/tech-debt.md) — 70 call sites, 3 versions |
| C5 | Field-level Meta interaction | Does an extra spec field change the *kind* of object Meta creates? | `postmortems/2026-07-14-mto-text-variations-fix.md`; `postmortems/META_DYNAMIC_CREATIVE_ERROR.md` |
| C6 | Asset readiness gate | Does the path wait for the upstream asset to be ready? | `src/launch/PRD/PRD.md` §6: video needs `fb_video_id` ready; [TD-22](architecture/tech-debt.md#td-22--large-video-upload-fails-with-meta-error-6000--1363048) |
| C7 | Access allowlists in source | Is visibility governed by a hardcoded list that will silently exclude new entities? | `lib/priority-ad-accounts.ts` (M-01); email allowlist in M-20 PM Feedback (TD-13); image-proxy substring allowlist (TD-24) |
| C8 | Webhook trust | Is the inbound payload verified before it mutates anything? | [TD-28](architecture/tech-debt.md#td-28--webhook-payloads-are-not-signature-verified) |

## D · Operational seams

| # | Seam | The question to ask | Evidence it has been missed |
|---|---|---|---|
| D1 | Scheduler actually runs | Does this depend on a cron that is currently disabled? | 9 cron endpoints, **scheduler disabled** (AS-IS README; [TD-05](architecture/tech-debt.md)) |
| D2 | Failure visibility | How would anyone know this broke? | [TD-06](architecture/tech-debt.md) — no logging, metrics, tracing, or uptime monitor |
| D3 | Executed test | Does any assertion for this run anywhere? | [TD-12](architecture/tech-debt.md) — 0 CI pipelines; 3 tests, one tests a copy of itself |
| D4 | Blast radius | No feature flags exist — is shipping to 100% of users at once acceptable here? | Modules Inventory §5: "Feature flags — none" |
| D5 | Deploy path | Does this need anything on the Mac mini Docker host or new env vars? | `runbooks/deployment.md`, `MACMINI_SETH_SETUP.md` |
| D6 | Unconfigured integration | Does this depend on a service whose token was never exchanged? | [TD-02](architecture/tech-debt.md) — Creative Portal / R2 unconfigured in every environment |

## E · Knowledge seams

| # | Seam | The question to ask | Evidence it has been missed |
|---|---|---|---|
| E1 | PRD updated in the same change | Does the feature's PRD still describe reality after this? | [TD-14](architecture/tech-debt.md); the `src/launch/PRD/PRD.md` §3 correction is the worked example |
| E2 | Back-link exists | Does the *other* module's doc reference this change? | AS-IS README: "How the documents connect" — the graph is the artifact |
| E3 | Counts not retyped | Did a hand-typed route/table count just drift? | [BL-34](product/backlog.md#bl-34--documentation-freshness-automation) — documentation freshness automation |
| E4 | Dead-doc reference | Does the doc link to a path that no longer exists — `AS-IS/`, `docs/`, `share/`, `_superseded-072826/`, `_archive/`, or a `072826 - ` filename? | All six were removed in the 28 Jul 2026 restructure; see `README.md` §Structure for the current homes |
| E5 | Deferred work has an id | Is every "not yet" in this change traceable to a TD or BL number? | The gap tables in `src/*/PRD/PRD.md` §7 are the intended home |

## F · Business and adoption seams — walk these first

| # | Seam | The question to ask | Evidence it has been missed |
|---|---|---|---|
| F1 | Named persona | Which persona from Product Overview §4 asked for this, and would they notice if it vanished? | M-15 · Rewards — shipped, **no identified owner, flagged as a removal candidate** (Modules Inventory) |
| F2 | Adoption depends on a new habit | Does using this require going somewhere the user does not already go? | M-12 · Presets is **not in the sidebar** — URL-only, so it is effectively unreachable (Modules Inventory §2); A3 is the same seam seen from the structure side |
| F3 | KPI attached, and measurable | Which of the eight KPIs moves — and can we observe it at all? | §11 lists eight KPIs; [BL-12](product/backlog.md) — **none instrumented** |
| F4 | Chosen, not assumed | Is there a `BL-xx` with a P&L score, and does the roadmap sequence it here? | Master Backlog is P&L-scored (BL-01…BL-36); [Short-term Roadmap](product/roadmap.md) |
| F5 | Duplicate capability | Does the product already do this somewhere else, and should that surface be extended instead of a new one added? | Three ads-creating routes; Gallery mode vs Table mode; [TD-21](architecture/tech-debt.md#td-21--campaign-creation-is-disconnected-from-launch) is what "add a second surface" produces |
| F6 | Real user provenance | Did anyone actually ask, or is this inferred? | `feedback/`; M-20 · PM Feedback exists precisely to capture this |
| F7 | Value ceiling known | What does today's workaround cost in minutes or errors? That number caps the value of the change | Product Overview §10 states each limitation **with its business consequence** — the pattern to follow |
| F8 | Blocked by a bigger gate | Is the value unreachable until something upstream lands? | [TD-01](architecture/tech-debt.md) / L1 — App Review not passed, so only Meta-app-role users can connect at all |
