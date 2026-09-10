# PM-OS Skills

A set of skills for AI agents doing product management work. Gates before specs, evidence before claims, adoption before "done".

Built on top of [obra/superpowers](https://github.com/obra/superpowers), [mattpocock/skills](https://github.com/mattpocock/skills), and [anthropics/skills](https://github.com/anthropics/skills). Full provenance in [skills/SOURCES.md](skills/SOURCES.md).

## Install

```bash
git clone https://github.com/dev-pati/PM-OS-Skills.git ~/Developer/pm-os-skills
cd ~/Developer/pm-os-skills
./install.sh <your-workspace>
```

Run it again any time to update. Your own writing in `AGENTS.md` survives — only the block between `<!-- pm-os:start -->` and `<!-- pm-os:end -->` gets replaced.

Needs `bash`, `python3`, `git`. `node` optional.

All 29 skills are prefixed `pm-` so they never collide with skills you installed from elsewhere.

## Why this exists

Most agent workflows fail in the same three places.

**A spec gets written before anyone asks whether the work should exist.** So you build the thing, ship it, and nobody uses it. The fix is two gates that run *before* a spec: who has the pain, which number moves, and which seams does this touch — traced forward *and* backward.

**"It works" means four different things.** Someone ran it locally. Someone read the diff. Someone remembers a conversation. Nobody checked production. The fix is a precedence that never collapses: `runtime > commit > chat > none`.

**Shipped gets recorded as done.** The adoption hypothesis from the spec is never re-checked. The fix is to go back to the runtime — not the diff — and see if anyone opened it.

## Gates

Two gates, in order. Nothing writes a spec until both pass.

| Gate | Asks | Fails closed when |
|---|---|---|
| **Business** | Who has this pain, what do they do today, which KPI moves, will it be adopted | You cannot name the persona or the adoption signal |
| **Connection** | Which seams does this touch — across eight planes, forward and reverse | The reverse trace is missing |

Killing or parking at a gate is a **successful outcome**. A gate that never stops anything is decoration.

| Skill | What it does |
|---|---|
| `/pm-build-connected` | Runs both gates, then chains the rest of the pipeline |
| `/pm-vault-system-thinking` | The eight-plane trace, including the reverse direction |
| `/pm-grilling` | Relentless one-question-at-a-time interrogation of a plan |
| `/pm-grill-with-docs` | Same, but leaves ADRs and a glossary behind |
| `/pm-domain-modeling` | Pins down the ubiquitous language before it drifts |

## Specs and tickets

| Skill | What it does |
|---|---|
| `/pm-to-spec` | Turns the conversation you already had into a spec. No interview |
| `/pm-to-tickets` | Breaks a plan into tracer-bullet tickets, each declaring its blocking edges |
| `/pm-wayfinder` | For work too big for one session — a map of decision tickets you resolve one at a time |
| `/pm-writing-plans` | Turns a spec into an implementation plan |

## Delivery

| Skill | What it does |
|---|---|
| `/pm-triage` | Moves issues through a state machine of triage roles, writes agent-ready briefs |
| `/pm-rollout-plan` | Preflight, steps, verification signals, rollback, comms |
| `/pm-verification-before-completion` | Blocks the "should work now" claim. Evidence or nothing |
| `/pm-systematic-debugging` | Four-phase root cause. Use before proposing any fix |
| `/pm-incident-postmortem` | Blameless structure. An incident should buy a rule, not a patch |

## Documentation

| Skill | What it does |
|---|---|
| `/pm-vault-knowledge-retrieval` | Searches your existing docs before you write new ones |
| `/pm-vault-note-creation` | New specs, PRDs, API contracts, dataflows |
| `/pm-vault-note-update` | Propagates one fact to every document that states it |
| `/pm-html-canvas` | Self-contained HTML decision docs for stakeholders |
| `/pm-architecture-diagram` | Dark-themed HTML+SVG diagrams |
| `/pm-bpmn` | PlantUML business process diagrams |

## Communication

| Skill | What it does |
|---|---|
| `/pm-internal-comms` | Status reports, leadership updates, FAQs, incident comms |
| `/pm-handoff` | Compacts this conversation for the next agent |
| `/pm-linear-problem-report` | Explains a pasted issue back as a short problem report |
| `/pm-evidence-backed-cross-project-replies` | Replies to another team using only facts you checked this session |
| `/pm-to-questionnaire` | Turns a decision you can't answer into a form someone else fills in |

## Research

| Skill | What it does |
|---|---|
| `/pm-research` | Investigates against primary sources, captures a cited note |
| `/pm-technical-spike` | Time-boxed spike with a stated exit criterion |
| `/pm-brainstorming` | Explores intent before any creative work. Approval gate never scales down |

## Meta

| Skill | What it does |
|---|---|
| `/pm-writing-for-agents` | Writing skills, `AGENTS.md`, `CLAUDE.md` |

## Load the minimum set

Two skills is typical. Four is a lot. Six means you haven't narrowed the task.

Routing table: [skills/meta/task-routing.md](skills/meta/task-routing.md). Full catalog: [skills/INDEX.md](skills/INDEX.md).

## The framework behind the skills

The skills enforce a workflow. The workflow is written down separately:

| Doc | Decides |
|---|---|
| [pm-operating-system.md](framework/pm-operating-system.md) | The whole loop — three phases, ten stages, request to adopted evidence |
| [product-development-framework.md](framework/product-development-framework.md) | Whether the work exists at all — the two gates in detail |
| [linear-collab.md](framework/linear-collab.md) | How a PM and one or more agents share a single Linear issue |
| [triage-labels.md](framework/triage-labels.md) | Five labels. `ready-for-agent` requires a passed Business gate |
| [issue-tracker.md](framework/issue-tracker.md) | Tracker conventions |

## What the installer touches

```text
<workspace>/
├── AGENTS.md              pm-os block written or updated in place
├── .pm-os-version         version + install date
└── Second Brain/
    ├── Knowledge/pm-os/   framework docs + canvas specs
    ├── Outputs/pm-os/     rendered HTML
    └── Skills/            29 skills, symlinked into every agent runtime
```

Skills are symlinked into `.claude/skills` and `.agents/skills` at the workspace root and inside every directory under `codebases/`. One copy on disk, every agent sees it.

Detail: [docs/install.md](docs/install.md).

## Honest limits

**Written for one product.** The framework names `BL-`/`TD-` ledgers, Meta ad semantics, and a specific Supabase boundary. Adapting it means rewriting those specifics, not renaming them. [docs/adapt.md](docs/adapt.md) splits what's portable from what isn't.

**`linear-collab.md` is proposed, not accepted.** Written 08/09/2026. MCP tool names match the interface connected that day. Verify before automating.

**The installer copies files.** It doesn't migrate, doesn't merge skills by content, and overwrites a skill of the same name. Fork under a new name instead of editing in place.

**Some skills assume an Obsidian vault.** The `pm-vault-*` skills expect a specific folder contract. If your knowledge layer differs, rewrite their paths or drop them and keep the gates.

## Docs

- [docs/install.md](docs/install.md) — what the installer touches, and what it never touches
- [docs/agents.md](docs/agents.md) — how an agent should read this framework
- [docs/linear-setup.md](docs/linear-setup.md) — wiring Linear MCP
- [docs/adapt.md](docs/adapt.md) — adapting to a workspace that isn't PATI

## Licence

MIT for locally authored material. Vendored skills keep their upstream licences — see [skills/SOURCES.md](skills/SOURCES.md).
HTML references are stored in the repository:

| Path | Purpose |
|---|---|
| [outputs/pm-operating-system-archify.html](outputs/pm-operating-system-archify.html) | Primary one-screen PM operating system render |
| [outputs/pm-workflow.html](outputs/pm-workflow.html) | Three-phase workflow render |
| [outputs/linear-feedback-loop.html](outputs/linear-feedback-loop.html) | Linear collaboration loop render |
| [skills/documentation/pm-architecture-diagram/resources/template.html](skills/documentation/pm-architecture-diagram/resources/template.html) | Architecture diagram reference template |
| [skills/superpowers/pm-brainstorming/scripts/frame-template.html](skills/superpowers/pm-brainstorming/scripts/frame-template.html) | Brainstorming visual frame template |

The installer copies the three rendered diagrams to `Second Brain/Outputs/pm-os/`. The two templates remain inside their installed skills.
