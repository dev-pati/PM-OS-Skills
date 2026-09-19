---
name: pk-vault-note-creation
description: Create new documents in this vault â€” feature specs (PRD/API/DATAFLOW/BPMN), tech plans, incident post-mortems, AS-IS documents, handoff notes â€” following AGENTS.md conventions and the vault's stable identifiers. Scans for existing coverage first so nothing is duplicated, reactivates superseded content instead of rewriting it, and runs an impact trace so the new document is connected into the graph rather than added beside it. Use when asked to document, spec, or write up something that does not yet have a home in the vault.
---

# Vault Note Creation

Create new documents in this vault. The rule that matters most: **a new document that nothing links to, and that links to nothing, has not been added to the vault â€” it has been dropped next to it.** Creation is not finished until the graph closes.

Ground yourself with [[vault-knowledge-retrieval]] first. If the new document describes a change to the product, run [[vault-system-thinking]] before writing it.

This vault is multi-project: every path below is relative to the active project's root, `01_brain/02_CONTEXT/<project>/` â€” today that means `01_brain/02_CONTEXT/AdLauncher/`. The one exception is the action-plan ticket template, which is shared at `workspace-root 03_agents/shared/templates/`.

---

## Document types and where they go

| Type | Path | Convention source | When |
|---|---|---|---|
| Feature PRD | `src/<feature>/PRD/PRD.md` | `AGENTS.md` Â§2 | Product requirements for a `src/` feature |
| Scoped sub-PRD | `src/<feature>/PRD/<Topic>.md` | follows Page Manager precedent (`Comment-Ops.md`, `Inbox-Ops.md`) | A distinct capability inside a large feature |
| API contract | `src/<feature>/API/API.md` | `AGENTS.md` Â§2 | Endpoints, shapes, auth, error cases |
| Tech plan | `src/<feature>/API/<Topic>-TechPlan.md` | precedent: `Realtime-Comment-Inbox-TechPlan.md` | Implementation design for a sub-PRD |
| BPMN | `src/<feature>/BPMN/BPMN.mermaid` (+ `BPMN.png`) | `AGENTS.md` Â§2 | Process flow for the feature |
| Data flow | `src/<feature>/DATAFLOW/DATAFLOW.mermaid` | `AGENTS.md` Â§2 | Where the feature's data comes from and goes |
| Incident post-mortem | `postmortems/<YYYY-MM-DD>-<slug>.md` | precedent: `2026-07-14-mto-text-variations-fix.md` | A production failure with a root cause |
| AS-IS document | `product/<name>.md` (PM view) or `architecture/<name>.md` (eng view) | `README.md` | **Rarely.** Only when the eight-document set genuinely lacks a dimension. Lowercase-kebab filename, no date prefix |
| Runbook / ops doc | `runbooks/<name>.md` | precedent: `runbooks/deployment.md` | Deploy, host, environment procedure |
| In-flight spec | `specs/<slug>/PRD.md` + `TechPlan.md` | precedent: `specs/media-sync/` | Work with no `src/` feature folder yet |
| Handoff | `integrations/<date>-<slug>.md` | precedent: `integrations/README.md` | Material for another team |
| Action-plan ticket | from `workspace-root 03_agents/shared/templates/ACTION-PLAN-UPDATE-TICKET.md` | that template | Status update in the agreed ticket format |

**Do not create a new `src/<feature>/` folder** unless the user explicitly asks. Features are manual-only (`AGENTS.md` Â§4). Auto-creating one adds a phantom feature to the app's next scan.

**Do not hand-write `_VerN` snapshot files.** Write the unsuffixed original; the app snapshots on sync (`AGENTS.md` Â§3).

---

## Instructions

### Phase 1 â€” Coverage scan (never skip)

1. **Search every layer for existing coverage** of the topic, within the active project's root: `product/`, `architecture/`, `src/**/`, `specs/`, `runbooks/`, `reference/`, `integrations/`, `postmortems/`. Record each match with its path, layer, and what it covers. There is no quarantine folder â€” the `_superseded-072826/` and `_archive/` trees were deleted on 28 Jul 2026.
2. **Classify each match:**
   - **Already covered, current** â†’ do not create. Hand off to [[vault-note-update]].
   - **Covered but stale** â†’ the document exists but contradicts the code. Do not write a second document beside it; reconcile the existing one via [[vault-note-update]] and record the divergence as a finding.
   - **Adjacent** â†’ a cross-link candidate. Record it in both directions.
   - **Genuinely new** â†’ proceed.
3. **Check the identifier registries.** If the topic corresponds to an existing `TD-`, `BL-`, `M-`, or `W` item, the new document must reference that identifier. If it needs a new one, take the next free number in range and add the entry to the owning AS-IS document in this same change.

### Phase 2 â€” Decompose

4. Decide whether this is one document or several, using the vault's own splits:
   - Requirements and implementation design are separate documents (PRD vs TechPlan), following the Page Manager precedent.
   - A capability large enough to have its own acceptance criteria gets its own sub-PRD, with a pointer from the feature's `PRD.md`.
   - A process belongs in `BPMN.mermaid`, not narrated inside a PRD.
   - Data movement belongs in `DATAFLOW.mermaid`, not in prose.
   - If the work spans two features, write in both feature folders and cross-link â€” do not write one document that quietly owns two features. That is how [TD-21](architecture/tech-debt.md#td-21--campaign-creation-is-disconnected-from-launch) came to exist.
   - Present the plan before writing if it is more than two documents.

### Phase 3 â€” Ground the content

5. **Read the code.** `02_projects/adlauncher/` is the source of truth. Enumerate real route paths, real table names, real component files, real line counts. Never describe behaviour you have not read â€” the AS-IS set exists because a PRD claimed behaviour that was inferred from the UI.
6. **Read the neighbours.** The relevant Modules Inventory entry, the adjacent feature PRDs, any `postmortems/` incident on this surface, and the canvases for the affected lane.
7. **Match the vault's register.** Feature PRDs in this vault are written in Vietnamese with English technical terms; the AS-IS set and `integrations/` are in English. Follow the language of the destination folder, and reuse the section shape of the sibling documents in that folder â€” read one before writing.
8. Use the web only for external specifications (Meta Graph, Supabase, a vendor API) and cite the URL inline. Internal behaviour comes from the code, never from the web.

### Phase 4 â€” Write

9. **Follow the sibling document's structure.** For a feature PRD that means, per the existing set: Má»¥c tiÃªu Â· User stories Â· Flow chÃ­nh Â· MÃ n hÃ¬nh & components Â· API & DB Â· Quy táº¯c nghiá»‡p vá»¥ Â· Tráº¡ng thÃ¡i & gap Â· Acceptance criteria. Do not invent a new layout for one feature.
10. **Include the connective tissue** â€” this is the part that is usually missing:
    - Relative links to the AS-IS documents and canvases that govern this surface.
    - The `TD-`/`BL-` identifiers for every known gap, in a gap table.
    - Links to the adjacent features this one hands work to or receives it from.
    - A dated verification line when the content is verified against a specific commit, in the style of the existing banners.
11. **Write acceptance criteria that assert cross-module outcomes**, not UI outcomes. At least one criterion must be observable outside the screen being specced (a row written, a downstream list updated, a Meta object created with the right shape).
12. **Back-link from the neighbours.** Add the pointer from every document that should now reference this one â€” the feature `PRD.md` for a sub-PRD, the other feature's PRD for a shared seam, the Modules Inventory entry when a module's surface changed. A one-directional link is an unfinished link.

### Phase 5 â€” Report

13. Save every file, new and modified.
14. Report: documents created (paths, what each covers) Â· superseded content carried forward Â· cross-links added **in both directions** Â· identifiers referenced or newly allocated Â· gaps deliberately left, each with its `TD-`/`BL-` id Â· what still needs verification against the code.

---

## Guidelines

- **Read a sibling document before writing a new one.** Conventions live in the files, not in memory of them.
- **Never duplicate.** If it exists and is current, update it. If it exists and is superseded, extract from it.
- **Never create a feature folder** without an explicit request; never hand-write `_VerN` files; always overwrite the unsuffixed original in the correct kind subfolder (`AGENTS.md` Â§3â€“4).
- **Every claim about the product gets a code path or a document citation.** No inference from screenshots or from the UI.
- **Every "not yet" gets an identifier.** An unnumbered gap is invisible in two weeks.
- **Two-way links or no link.**
- **Prefer a short, correct, connected document** over a long one that restates what the AS-IS set already says. Point at the canonical document instead of copying it â€” copies drift (TD-14).
- Date things absolutely (`25/07/2026`), never "last week".

---

*Adapted for this vault from [jamesmcroft/obsidian-ai-second-brain](https://github.com/jamesmcroft/obsidian-ai-second-brain) (MIT). Upstream creates PARA notes from templates; this version creates the document types this vault actually has, under `AGENTS.md` conventions, with the impact-trace and back-link requirements added.*
