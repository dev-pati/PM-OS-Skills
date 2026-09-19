---
name: pk-build-connected
description: The pipeline for building anything in AdLauncher. Runs two hard gates before code exists â€” a business gate (which problem, whose problem, which KPI, will it be adopted) and a connection gate (which seams, traced across all planes) â€” then chains grilling, domain modeling, spec, tracer-bullet tickets, TDD implementation, code review, and the vault doc close-out. Use at the START of any feature, change, or idea, and whenever asked to build, add, implement, or ship something. Refuses to produce a spec for work that cannot name its business problem or its adoption signal.
disable-model-invocation: true
---

# Build Connected

The standing process for building anything in this product. It exists because of two failure modes this project has already paid for:

1. **Features that work and nobody needs.** Volume of features is not progress. A screen that ships and is never opened cost more than it returned, and â€” with no analytics instrumentation (BL-12, `01_brain/02_CONTEXT/AdLauncher/product/backlog.md#bl-12--kpi-instrumentation`) â€” nobody will ever find out.
2. **Features that connect to nothing.** The UI lands, the seams don't. TD-21 (`01_brain/02_CONTEXT/AdLauncher/architecture/tech-debt.md#td-21--campaign-creation-is-disconnected-from-launch`): campaign creation and Launch both work perfectly and share no state, preset, or naming schema. Two working features, one broken product.

So: **simple features that map to a business problem, wired into everything they touch.** Not many features. Not clever features.

This skill is the orchestrator. It owns the order; the specialist skills own the depth.

---

## Gate 1 â€” Business gate

**Nothing proceeds until every row is answered.** Do not write a spec, do not open a ticket, do not read the code for implementation purposes. If the user pushes past this, ask once more, and if they reaffirm, proceed on their call but record the unanswered rows in the spec's Further Notes as accepted risk â€” their decision, visibly theirs.

Get grounded first: `/vault-knowledge-retrieval` for the business context â€” Product Overview Â§1â€“Â§4 (purpose, problems solved, personas), Â§10 (L1â€“L9 limitations *with their business consequence*), Â§11 (the eight KPIs), the Master Backlog's P&L scoring, and `feedback/` for what users actually complained about.

Then run `/grilling` â€” or `/grill-with-docs` when the terminology is fuzzy, which also sharpens `CONTEXT.md` â€” until this table is full:

| # | Question | Not an acceptable answer |
|---|---|---|
| B1 | **Whose problem is this?** Name the persona from Product Overview Â§4 and the role from Â§5 | "Users" |
| B2 | **What do they do today instead?** The current workaround, in steps, with its cost in minutes or errors | "It's manual" |
| B3 | **Which business problem does this solve?** Map it to Product Overview Â§2, or to an `L`-numbered limitation and its stated business consequence | "It would be nice to have" |
| B4 | **Which KPI moves, and in which direction?** One of the eight in Â§11. State the expected size of the move | "It improves UX" |
| B5 | **Which BL item is this?** An existing `BL-xx`, or a new one appended to the Master Backlog with its P&L score in this same change | "It's not on the backlog" |
| B6 | **What is the adoption hypothesis?** Who opens this, how often, in which existing habit does it sit â€” and what makes them come back | "They'll use it because it's better" |
| B7 | **How will we know if it is unused?** Name the signal. If there is none, say so explicitly and cite BL-12 â€” accepted blindness, not an oversight | silence |
| B8 | **What is the smallest version that tests B6?** The thinnest slice that would prove or kill the adoption hypothesis | the full feature |
| B9 | **What happens if we don't build it?** | "We fall behind" |

Two outcomes are both successes:

- **Pass** â†’ continue to Gate 2 with B8 as the scope. Not the full idea â€” B8.
- **Kill or park** â†’ say so plainly, record it in the Master Backlog with the reason (`wontfix` gets a line too â€” see `workspace-root 03_agents/shared/agents/triage-labels.md`), and stop. Declining to build something is the highest-leverage output this gate produces.

**Scope discipline.** The deliverable is B8, the smallest version that tests the hypothesis. Anything beyond it is a separate BL item, not a stretch goal quietly attached to this one.

---

## Gate 2 â€” Connection gate

Run `/vault-system-thinking` on the scope from B8. It produces the Impact Trace across all planes â€” business, process, modules, API, data, external contract, cross-cutting, knowledge â€” and it is where the reverse trace happens: *who else touches what I am about to change.*

Write it to `07_temp/scratch/<feature-slug>/impact-trace.md`.

**The gate holds when:** every plane is marked Connected / Deferred / N-A with a reason; every Deferred seam carries a `TD-` or `BL-` id; the adjacent W-lane has been checked for a handoff that should exist; and at least one cross-module acceptance criterion is written.

An unnamed deferred seam is how TD-21 happened. A named one is a backlog item with a price.

---

## The pipeline

Gates first. Then:

| # | Step | Skill | Output |
|---|---|---|---|
| 0 | Ground in the vault | `/vault-knowledge-retrieval` | business + system context, cited |
| 1 | **Gate 1 â€” business** | `/grilling` or `/grill-with-docs` | B1â€“B9 answered; scope = B8 |
| 2 | Sharpen the language | `/domain-modeling` | `CONTEXT.md` terms, an ADR if a decision got made |
| 3 | **Gate 2 â€” connection** | `/vault-system-thinking` | `07_temp/scratch/<slug>/impact-trace.md` |
| 4 | Design the seams | `/codebase-design` | deep module, fewest seams, highest seam |
| 5 | De-risk a design question | `/prototype` | throwaway artifact â€” only when "how should it behave" is the open question |
| 6 | Write the spec | `/specs` then `/to-spec` | `07_temp/scratch/<slug>/spec.md` â€” see required additions below |
| 7 | Slice it | `/to-tickets` | `07_temp/scratch/<slug>/issues/NN-*.md`, tracer bullet first |
| 8 | Build it | `/implement` â†’ `/tdd` | code in `02_projects/adlauncher/`, tests at the agreed seams |
| 9 | Review it | `/code-review` | Standards + Spec axes |
| 10 | **Close the docs graph** | `/vault-note-update` | `src/<feature>/` specs + AS-IS documents updated, propagation set applied, TD/BL resolved |
| 11 | Check adoption | â€” | see below |

For an effort too large for one session â€” a migration, a rearchitect, an unclear destination â€” replace steps 1â€“7 with `/wayfinder`, and put "`/vault-knowledge-retrieval`, `/vault-system-thinking`, business gate B1â€“B9" in the map's `## Notes` so every session inherits the gates.

For a bug rather than a feature, skip Gate 1 (the problem is self-evident) but **never skip Gate 2** â€” bug fixes cross seams as readily as features. Use `/systematic-debugging`, then step 8 onward.

Run `/improve-codebase-architecture` on a cadence â€” every few days, or after any change to `launch/page.tsx` â€” independently of this pipeline. Agents accelerate entropy; this is the counterweight.

---

## The spec must carry the gates

`/to-spec` produces its own template. On this project the spec additionally opens with:

```markdown
BL: BL-xx
Status: ready-for-agent

## Business Gate
| | |
|---|---|
| Persona / role | |
| Today's workaround and its cost | |
| Business problem (Â§2 / L-x) | |
| KPI moved, expected direction and size | |
| Adoption hypothesis | |
| Signal that it is unused | |
| Smallest version testing the hypothesis | |

## Impact Trace
See [impact-trace.md](./impact-trace.md) â€” N seams connected, M deferred (BL-xx, TD-xx).
```

A spec without these two blocks has not passed the gates and is not `ready-for-agent`.

---

## Tickets: tracer bullet first

`/to-tickets` slices the spec. On this project the **first** ticket is always the thinnest slice that goes end to end and is **observable outside the UI** â€” a row written, a Meta object created, a downstream list updated. Not "build the dialog".

Rationale: with no CI, no feature flags, and no observability, a UI-first slice can look finished while the seams are untouched. An end-to-end slice fails loudly and early, which on this stack is the only feedback available.

Every ticket names the plane it closes from the Impact Trace. A ticket that closes no plane is scope creep.

---

## Step 11 â€” adoption check

The pipeline does not end at merge. Two states after shipping, and they are different:

- **Shipped** â€” it is in production.
- **Adopted** â€” the persona from B1 used it more than once, without being asked.

Schedule the adoption check when the work lands: a date, and the signal from B7. Then:

- **Adopted** â†’ record it in the feature PRD. A validated adoption hypothesis is the most reusable knowledge this project can produce.
- **Not adopted** â†’ this is a finding, not a failure. Write it up: what the hypothesis was, what actually happened, why. Consider removing the feature â€” M-15 Rewards is already flagged as a removal candidate with no identified owner. Dead features are not free; they carry maintenance, surface area, and the illusion of progress.
- **Cannot tell** â†’ BL-12 again. Say it out loud each time; that is what eventually gets instrumentation funded.

---

## Guidelines

- **Fewer, connected, adopted.** In that order. If you have to choose between a second feature and connecting the first one, connect the first one.
- **The gates are not paperwork.** Gate 1 kills bad work before it costs anything; Gate 2 makes the cost of a shortcut visible. Both should sometimes stop the work â€” a gate that never blocks isn't a gate.
- **B8, not the whole idea.** Ship the smallest version, learn, then decide. The full version is a later BL item.
- **Never skip the reverse trace.** Forward tracing only finds what you already knew you were touching.
- **Deferring is fine; deferring silently is not.** Every "later" gets a TD or BL id.
- **Code and docs land together.** A change is not done while its PRD tells the old story (`01_brain/02_CONTEXT/AdLauncher/README.md`; TD-14, `01_brain/02_CONTEXT/AdLauncher/architecture/tech-debt.md`).
- **The code outranks the documents**, always. Discrepancies are findings, routed to `/vault-note-update`.
- **Use the glossary's words** â€” `01_brain/02_CONTEXT/AdLauncher/CONTEXT.md` and Product Overview Â§13. Consistent naming is what makes the codebase navigable for the next agent.
- **Report honestly.** If a step was skipped, say which and why. If the adoption check has not happened yet, say that rather than implying the work is finished.
