# Issue tracker: Local Markdown, inside the vault

Specs and implementation tickets live as markdown files under `.scratch/` at the **vault root** (`Adlauncher Apps/`), not in the app repo. The vault is the second brain — work in flight sits next to the AS-IS set that governs it.

GitHub Issues on `dev-pati/New-Ads-Launcher` is deliberately **not** used as the tracker. Solo ownership plus a documentation-graph vault means a second queue on GitHub would fragment the context. If that changes, re-run `/setup-matt-pocock-skills` and switch.

## The intake queue is the Master Backlog, not `.scratch/`

This is the rule that keeps the two systems from drifting apart:

- **`product/backlog.md` (BL-01…BL-36) is the queue.** It is scored by P&L and is where work is *chosen*. Nothing enters `.scratch/` without a BL id — either an existing one or a new one appended to the Master Backlog in the same change.
- **`.scratch/<feature-slug>/` is the workbench.** It holds the spec and tickets for the one BL item currently in flight, and is disposable once the work lands in the code and the docs graph.
- **`src/<feature>/PRD/` and the AS-IS set are the destination.** When the work ships, the durable record lands there via `/vault-note-update`. A finished `.scratch/` directory is not a record of anything.

`architecture/tech-debt.md` (TD-01…TD-28, S1–S8) is the other half of the queue: risk and breakage rather than value.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`. Its first line names the BL id it serves.
- Implementation tickets are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` — never one combined file
- Triage state is a `Status:` line near the top of each file (role strings in `triage-labels.md`)
- Conversation appends to the bottom under `## Comments`
- The Impact Trace produced by `/vault-system-thinking` is stored at `.scratch/<feature-slug>/impact-trace.md` and referenced from the spec

## When a skill says "publish to the issue tracker"

Create the file under `.scratch/<feature-slug>/`, creating the directory if needed. Then add or update the corresponding BL entry in the Master Backlog so the queue and the workbench agree.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. Resolve a bare `BL-xx` / `TD-xx` against the AS-IS documents.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `.scratch/<effort>/map.md` — Destination / Notes / Decisions-so-far / Not yet specified / Out of scope
- **Child ticket**: `.scratch/<effort>/issues/NN-<slug>.md`, numbered from `01`. A `Type:` line records `research`/`prototype`/`grilling`/`task`; a `Status:` line records `claimed`/`resolved`
- **Blocking**: a `Blocked by: NN, NN` line near the top. Unblocked when every listed file is `resolved`
- **Frontier**: files in `.scratch/<effort>/issues/` that are open, unblocked, unclaimed; lowest number first
- **Claim**: set `Status: claimed` and save before any work
- **Resolve**: append the answer under `## Answer`, set `Status: resolved`, append a gist + link to Decisions-so-far in `map.md`
- The map's `## Notes` block should name the BL id, and the skills every session must consult: `/vault-knowledge-retrieval`, `/vault-system-thinking`

## Git, and where it lives

The vault root is **not** a git repository. The application is: `codebases/AdLauncher/`, remote `dev-pati/New-Ads-Launcher`, default branch `main`.

Consequences for the skills:

- `/implement` and `/code-review` operate on `codebases/AdLauncher/` — run git there, never at the vault root.
- Doc changes in the vault are not versioned by git. `AGENTS.md` §3 versioning applies instead: overwrite the unsuffixed original and let the app snapshot `_Ver<N>` on sync.
- `/code-review`'s "fixed point" is a commit or merge-base inside `codebases/AdLauncher/`.
- A change that spans both — code plus vault docs — is one unit of work with two write targets. Both land before it is done.
