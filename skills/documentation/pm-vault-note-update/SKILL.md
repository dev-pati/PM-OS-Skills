---
name: pm-vault-note-update
description: Update existing vault documents — feature PRDs, API contracts, dataflows, AS-IS documents, tech debt and backlog entries — so the change lands across the graph instead of in one file. Locates the right document, reconciles it against the code, merges additively, propagates the change to every document that shares the seam, and keeps TD/BL/M/W identifiers stable. Use when asked to update, correct, enrich, or reconcile any document, or after a code change that makes a document stale.
---

# Vault Note Update

Update documents in this vault. The failure mode this skill prevents is the one the vault has already paid for: **one document gets the update, its neighbours keep the old story, and three weeks later nobody trusts any of them** ([TD-14](architecture/tech-debt.md) — documentation contradicts the code).

So an update here is never a single-file edit. It is: find the seam, correct the document, then correct every other document standing on the same seam.

Ground yourself with [[vault-knowledge-retrieval]]. If the update is driven by a product change, run [[vault-system-thinking]] first and attach its Impact Trace.

This vault is multi-project: every path below is relative to the active project's root, `Second Brain/projects/<project>/` — today that means `Second Brain/Projects/AdLauncher/`. `reference/agents/issue-tracker.md` and `triage-labels.md` are the exception — always shared, at `Second Brain/System/agents/`.

---

## When to use

| Signal | Action |
|---|---|
| "Update the PRD for X" | Locate, reconcile against code, merge, propagate |
| "This doc is wrong / outdated" | Verify against `codebases/AdLauncher/`, correct with a dated correction note |
| Code changed | Update the affected documents **in the same change** (`README.md`) |
| "Add TD/BL item" | Append to the owning AS-IS document, next free number, existing scoring format |
| "Mark TD-xx fixed" | Verify by pattern across the codebase, not by one file — see below |
| "Split this doc, it's too big" | Decompose per [[vault-note-creation]] Phase 2, leave a pointer behind |
| "Link X and Y" | Add the reference in **both** documents |

---

## Non-negotiable conventions

From `AGENTS.md` and `README.md`:

- **Overwrite the unsuffixed original** (`PRD.md`, `API.md`, `DATAFLOW.mermaid`, `OVERVIEW.md`) in the exact correct kind subfolder. Never hand-write a `_VerN` snapshot — the app creates those on sync.
- **Never renumber** `TD-`, `BL-`, `S`, `M-`, or `W` identifiers, and never reuse a retired number.
- **Never delete content** unless the user asks for a correction or removal. Updates are additive; corrections are marked, not silently overwritten.
- **Preserve `.canvas` validity.** These are JSON Canvas 1.0 files. Edit node text and add nodes/edges; do not break the schema, and do not reflow the layout as a side effect.
- **The quarantine folders are gone.** `_superseded-072826/` and `_archive/` were deleted on 28 Jul 2026. A link into either is a dead link — report it, do not try to follow it.
- **Update the affected document in the same change as the code.** A document updated a month later is a document nobody trusts.

---

## Instructions

### Phase 1 — Locate and read

1. **Find the target.** Named document → open it. Described topic → search all layers (`product/`, `architecture/`, `src/**/`, `specs/`, `runbooks/`, `reference/`, `integrations/`, `postmortems/`) and present candidates if more than one plausibly owns the change. If several documents cover the topic, the AS-IS set (`product/` + `architecture/`) is canonical and the feature spec is subordinate — update both, and say which one you treated as authoritative.
2. **Read the target in full**, including its verification banner, its gap table, and every identifier it references. Note how stale it claims to be.
3. **Read a sibling** in the same folder to confirm the current section shape before editing.

### Phase 2 — Reconcile against the code

4. **Verify the target's existing claims** about the area you are touching against `codebases/AdLauncher/`. This step is why this vault exists: the launch PRD's "chỉ launch vào ad set CÓ SẴN" was true when written, was inherited into a later document unchecked, and produced a wrong conclusion about what the product can do.
5. **Verify by pattern, not by file.** When checking whether something is fixed, grep the whole codebase for the pattern. Security finding S3 was recorded as fixed after remediation in one file; the pattern spanned 44 files and 125 occurrences.
6. **Record discrepancies as findings**, not as quiet edits. A document that was wrong is evidence about how the vault drifts — worth a line in the correction and, if systemic, a `TD-`/`BL-` item.

### Phase 3 — Find every document on the same seam

7. **Enumerate the propagation set.** For the fact you are changing, list every other document that states it or depends on it:
   - The Modules Inventory entry for the module (`Related APIs` / `Related tables` / `Dependencies` / `Known issues` rows).
   - Every *other* module entry naming the same route, table, or `lib/` file — grep for it.
   - The adjacent feature's PRD when the change crosses a seam.
   - The affected `.canvas` node (BPMN lane, Data Flow layer, API Map group).
   - `Technical Debt` / `Master Backlog` entries whose description this change invalidates or resolves.
   - `Product Overview` / `Technical Architecture` when scope, integrations, limitations, or counts move.
8. **Reactivate rather than restate.** If the content already exists in another current document, link to it instead of copying. Copies are how TD-14 reproduces.

### Phase 4 — Apply

9. **Merge additively into the right section.** Match the existing bullet style, heading depth, and table columns. For feature PRDs the sections have fixed meanings: goal → §1, stories → §2, flow → §3, screens/components → §4, API & DB → §5, business rules → §6, gaps → §7, acceptance criteria → §8.
10. **Mark corrections explicitly**, in the vault's established style — a dated `> **Đính chính (DD/MM/YYYY).**` block that states what the old text said, what is actually true, and the identifier that tracks the remaining work. Do not delete the wrong claim without saying it was there; readers who remember it need to know it was addressed.
11. **Update the verification banner** to the date and basis commit you verified against, or leave the existing "unverified since" banner intact if you did not verify — never upgrade a banner you did not earn.
12. **Propagate.** Apply the corresponding edit to every document in the propagation set from step 7. Add the back-link in each. This is the step that distinguishes an update from a surface edit.
13. **Move gaps into identifiers.** Anything newly discovered as missing goes into the feature's §7 gap table **and** gets a `TD-` or `BL-` entry, in the existing format with the existing scoring columns.
14. **Do not retype generated counts.** Route, table, migration, and Graph-version counts drift when hand-edited — recount from the code or leave them with their as-of basis and reference [BL-34](product/backlog.md#bl-34--documentation-freshness-automation).

### Phase 5 — Report

15. Save every modified file.
16. Report: documents updated with a one-line summary each · claims corrected, with old vs verified · propagation set and what was changed in each · cross-links added both ways · identifiers allocated or resolved · anything you could **not** verify, named as an open investigation item rather than left silent.

---

## Guidelines

- **One document updated is an incomplete update.** If the propagation set is genuinely empty, say so — that is a claim, and it should be a deliberate one.
- **Code outranks documents, always.** Report the discrepancy; do not quietly conform the code's story to the document.
- **Additive by default, corrections marked, deletions only on request.**
- **Two-way links or no link.**
- **Never renumber identifiers. Never hand-write `_VerN` files. Never auto-create feature folders.**
- **Keep the destination's language** — Vietnamese feature PRDs stay Vietnamese, the AS-IS set stays English. Do not translate a document as a side effect of updating it.
- **Absolute dates only.**
- **Keep edits scoped.** Do not reformat, reorder, or "improve" sections outside the change — except to add a missing back-link, which is always in scope.

---

*Adapted for this vault from [jamesmcroft/obsidian-ai-second-brain](https://github.com/jamesmcroft/obsidian-ai-second-brain) (MIT). Upstream updates PARA notes; this version adds code reconciliation, the propagation set, identifier discipline, and the `AGENTS.md` versioning rules this vault runs on.*
