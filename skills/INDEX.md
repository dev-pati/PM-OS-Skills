# Skills index

29 skills · 7 domains. Invoke `/<skill>`. Routing: [`meta/task-routing.md`](meta/task-routing.md). Sources: [`SOURCES.md`](SOURCES.md).

PM-facing subset of the PATI library. Stack-specific skills (Lark, Supabase, React, …) are deliberately excluded — see [`../docs/adapt.md`](../docs/adapt.md).

## communication (5)

| Skill | Purpose |
|---|---|
| `evidence-backed-cross-project-replies` | Use when replying on a shared issue thread to another team's blocker/access/status questions about your repo, PR, or deployment — especially under… |
| `handoff` | Compact the current conversation into a handoff document for another agent to pick up. |
| `internal-comms` | A set of resources to help me write all kinds of internal communications, using the formats that my company likes to use. Claude should use this… |
| `linear-problem-report` | Use when the user pastes a Linear issue, ticket, spec, or bug prompt and wants it explained back as a short Vietnamese problem report — what was… |
| `to-questionnaire` | Turn a decision you can't fully answer into a questionnaire for someone else to fill in. |

## delivery (5)

| Skill | Purpose |
|---|---|
| `incident-postmortem` | 'Use when an outage, production incident, or significant service degradation has occurred and the team needs to write a structured blameless… |
| `rollout-plan` | 'Generate comprehensive rollout plans with preflight checks, step-by-step deployment, verification signals, rollback procedures, and communication… |
| `to-tickets` | Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the… |
| `triage` | Move issues and external PRs through a state machine of triage roles — categorise, verify, grill if needed, and write agent-ready briefs. |
| `wayfinder` | Plan a huge chunk of work — more than one agent session can hold — as a shared map of decision tickets on your issue tracker, and resolve them one… |

## documentation (6)

| Skill | Purpose |
|---|---|
| `architecture-diagram` | Fallback for dark-themed HTML+SVG architecture diagrams, hand-placed from resources/template.html. Prefer /archify for any new diagram: it… |
| `bpmn` | Create business process diagrams using PlantUML syntax with BPMN, EIP, and Lean Mapping stencil icons. Best for workflow automation, approval… |
| `html-canvas` | Build self-contained HTML proposal/brief canvases for AdLauncher using the app design system (Star Admin 2 Pro tokens, Manrope, light/dark,… |
| `vault-knowledge-retrieval` | Search and synthesise knowledge from this vault — the AS-IS document set (product/ and architecture/), per-feature specs under src/<feature>/,… |
| `vault-note-creation` | Create new documents in this vault — feature specs (PRD/API/DATAFLOW/BPMN), tech plans, incident post-mortems, AS-IS documents, handoff notes —… |
| `vault-note-update` | Update existing vault documents — feature PRDs, API contracts, dataflows, AS-IS documents, tech debt and backlog entries — so the change lands… |

## meta (1)

| Skill | Purpose |
|---|---|
| `writing-for-agents` | Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md. |

## product (6)

| Skill | Purpose |
|---|---|
| `build-connected` | The pipeline for building anything in AdLauncher. Runs two hard gates before code exists — a business gate (which problem, whose problem, which… |
| `domain-modeling` | Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an… |
| `grill-with-docs` | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| `grilling` | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger… |
| `to-spec` | Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just synthesis of what you've already discussed. |
| `vault-system-thinking` | Trace a change across every plane of the system before it is called done — business (persona, KPI, adoption), process (W-lanes), modules (M-ids),… |

## research (2)

| Skill | Purpose |
|---|---|
| `research` | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic… |
| `technical-spike` | 'Create time-boxed technical spike documents for researching and resolving critical development decisions before implementation.' |

## superpowers (4)

| Skill | Purpose |
|---|---|
| `brainstorming` | You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user… |
| `systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes |
| `verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and… |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code |
