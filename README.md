# PATI PM Operating System

A living framework an agent can install, read, and follow. One command installs it
into any workspace; run it again to update.

> **Repos = Code** · **Second Brain = everything outside code** · **Framework = how the work moves**

## Install

```bash
git clone https://github.com/dev-pati/pati-pm-os.git ~/Developer/pati-pm-os
cd ~/Developer/pati-pm-os
./install.sh ~/Developer/PATI
```

Re-run the same command to update. Your own writing in `AGENTS.md` is preserved:
only the block between `<!-- pm-os:start -->` and `<!-- pm-os:end -->` is replaced.

Requires `bash`, `python3`, and `git`. `node` is optional — without it
`/archify` cannot render diagrams and the installer says so.

## What lands where

```text
<workspace>/
├── AGENTS.md                          pm-os block written or updated in place
├── .pm-os-version                     version + install date
└── Second Brain/
    ├── Knowledge/pm-os/               the framework, 5 docs
    │   └── canvas/                    diagram specs (archify JSON, .canvas)
    ├── Outputs/pm-os/                 rendered HTML you can open right now
    └── Skills/                        29 skills, linked into every agent runtime
```

Skills are symlinked into `.claude/skills` and `.agents/skills` at the workspace
root and inside every directory under `codebases/`. One copy on disk, every agent
sees it.

## The framework

| Doc | What it decides |
|---|---|
| [pm-operating-system.md](framework/pm-operating-system.md) | The whole loop: three phases, ten stages, from request to adopted evidence |
| [product-development-framework.md](framework/product-development-framework.md) | Whether the work exists at all. Gates B1–B9 and the eight-plane impact trace |
| [linear-collab.md](framework/linear-collab.md) | How a PM and one or more agents share one Linear issue as the progress record |
| [triage-labels.md](framework/triage-labels.md) | The five labels. `ready-for-agent` requires a passed Gate 1 |
| [issue-tracker.md](framework/issue-tracker.md) | Tracker conventions |

Three ideas carry the rest:

**Two gates before any spec.** Business (who, what pain, which KPI, will it be
adopted) then Connection (which seams, traced forward *and* backward). Killing or
parking at a gate is a successful outcome, not a failure.

**Evidence has a precedence.** `runtime > commit > chat > none`, never collapsed.
A green test run is not a deployment. A skipped required test did not pass.

**Shipped is not adopted.** Adoption re-checks the adoption hypothesis in the
runtime, not in the diff. An incident buys a structural rule, not a patch.

## Diagrams

Specs live in `canvas/`, renders in `outputs/`. Open
`outputs/pm-operating-system-archify.html` to see the loop in one screen.

Built with `/archify`, which validates geometry, proves desktop containment in a
real browser, and reports SHA-256 receipts. To rebuild after editing a spec:

```bash
node ~/.agents/skills/archify/bin/archify.mjs validate workflow canvas/pm-operating-system.workflow.json --quality showcase --json
node ~/.agents/skills/archify/bin/archify.mjs deliver  workflow canvas/pm-operating-system.workflow.json outputs/pm-operating-system-archify.html --quality showcase --json
node ~/.agents/skills/archify/bin/archify.mjs visual-check outputs/pm-operating-system-archify.html --json
```

Archify is **not** bundled — it lives at `~/.agents/skills/archify/`. See
[docs/adapt.md](docs/adapt.md) if you want to vendor it.

## Skills

29 skills across seven domains, PM-facing only. The 30 PATI-specific ones
(`lark-*`, `supabase`, `react-best-practices`, …) stay out of this repo
on purpose.

Load the **minimum sufficient set**. Two is typical, four is a lot, six is a red flag.
Routing table: [skills/meta/task-routing.md](skills/meta/task-routing.md).

## Docs

- [docs/install.md](docs/install.md) — what the installer touches, and what it never touches
- [docs/linear-setup.md](docs/linear-setup.md) — wiring Linear MCP for collaborative work
- [docs/agents.md](docs/agents.md) — how an agent should read this framework
- [docs/adapt.md](docs/adapt.md) — adapting it to a workspace that is not PATI

## Honest limits

- The framework was written for **AdLauncher**. It names `BL-`/`TD-` ledgers,
  Meta ad semantics, and a specific Supabase boundary. Adapting it to another
  product means rewriting those specifics, not just renaming them.
- `linear-collab.md` is a **proposed** operating design from 08/09/2026, not an
  accepted team process. MCP tool names match the interface connected on that date.
- The installer copies files. It does not migrate anything, does not merge existing
  skills by content, and overwrites same-named skills.

## Licence

MIT for the local-authored material. Vendored skills keep their upstream licences —
see [skills/SOURCES.md](skills/SOURCES.md) once generated.

