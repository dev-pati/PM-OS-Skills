# Impact Trace — template

Copy this into the response (and into the feature PRD when the change is significant). Every row gets a status: **Connected** (handled in this change), **Deferred** (with a TD/BL id), or **N-A** (with a one-line reason). No blank cells.

Paths in this template (`src/<feature>/`, `architecture/tech-debt.md`, `product/backlog.md`) are relative to the active project's root, `01_brain/02_CONTEXT/<project>/`.

---

## Impact Trace — `<change name>` · `<date>`

**Business anchor** — fill this before anything below it

| | |
|---|---|
| Persona / role (Overview §4–§5) | |
| Problem (§2 or `L-x`) + its stated business consequence | |
| Today's workaround, and its cost in minutes or errors | |
| KPI moved (§11), direction, rough size | |
| Backlog id | `BL-xx` — existing / appended in this change |
| Adoption hypothesis — who opens it, how often, inside which habit | |
| Signal that it is unused | … / **none — BL-12**, accepted blindness |
| Smallest version that tests the hypothesis | |

Everything below traces **the smallest version**, not the full idea.

**Anchor**

| | |
|---|---|
| Feature folder | `src/<feature>/` |
| Module | `M-xx · <name>` |
| BPMN lane | `Wx · <process>` |
| Adjacent lane(s) | `Wy · <process>` — handoff exists / missing |
| Change type | new surface / new field / new route / schema / behaviour / integration |

**Planes**

| Plane | What this change touches | Who else touches it (reverse trace) | Status | Note |
|---|---|---|---|---|
| 0 · Business | | | | |
| 1 · Process | | | | |
| 2 · Modules | | | | |
| 3 · API | | | | |
| 4 · Data | | | | |
| 5 · External contract | | | | |
| 6 · Cross-cutting | | | | |
| 7 · Knowledge | | | | |

**Cross-cutting, answered explicitly**

| Concern | Answer |
|---|---|
| Errors — normalised, surfaced, persisted? | |
| Caching — what goes stale, what invalidates? | |
| Rate limiting — new Meta calls on a hot path? | |
| Observability — how would we know it broke? | |
| Testing — which assertion, executed where? | |
| Feature flags — ships to everyone at once; acceptable? | |

**Seam registry hits**

| Seam | Hit | Resolution |
|---|---|---|
| e.g. F2 · Adoption depends on a new habit | yes | Connected — placed inside the existing Launch flow |
| e.g. B1 · `launch_batches` insert | yes | Connected — insert added to the new route |
| e.g. A2 · Naming schema | yes | Deferred — BL-xx |

**Deferred seams → tracked identifiers**

| Seam | New id | Where recorded |
|---|---|---|
| | TD-xx / BL-xx | `architecture/tech-debt.md`, `product/backlog.md`, `src/<feature>/PRD/PRD.md` §gap table |

**Documents updated in this change**

- `src/<feature>/PRD/PRD.md` — …
- `src/<other-feature>/PRD/PRD.md` — back-link added
- `product/…` or `architecture/…` — …

**Cross-module acceptance criteria**

1. …
2. …

**Residual risk knowingly accepted**

> One paragraph. What can still go wrong, who it affects, and why shipping anyway is the right call.

**Adoption check**

| | |
|---|---|
| Date to check | |
| Signal to look at | … / none — BL-12 |
| Outcome | adopted / not adopted / cannot tell — filled in after the check |
