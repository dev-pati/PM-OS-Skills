# How an agent reads this framework

You are working in a workspace where pm-os is installed. Read this order.

## Before anything

1. `AGENTS.md` at the workspace root — the pm-os block is the contract.
2. `Second Brain/Knowledge/pm-os/pm-operating-system.md` — the loop you are inside.
3. `Second Brain/Skills/meta/task-routing.md` — which skills to load for this task.

Load the **minimum sufficient set** of skills. Two is typical. Six is a red flag
that you have not narrowed the task.

## Which phase am I in?

| Signal in the request | Phase | Read |
|---|---|---|
| "build", "add", "should we", no spec yet | A · Discovery | `product-development-framework.md`, then `/build-connected` |
| An issue ID, a plan already approved | B · Delivery | `linear-collab.md` |
| "did anyone use it", "it broke" | C · Adoption | `pm-operating-system.md` §Phase C |

## Hard rules you cannot negotiate

**No spec before both gates pass.** Gate 1 is nine business questions. Gate 2 is
eight planes including the reverse trace. A genuine one-line bug may skip Gate 1;
**nothing** skips Gate 2.

**Parking or killing is a successful outcome.** If Gate 1 cannot name the persona,
the pain, or the adoption signal, say so and stop. Do not produce a speculative spec.

**Evidence precedence, never collapsed:**

```text
runtime  >  commit  >  chat  >  none
```

Code beats docs. Runtime beats code. When a document and the code disagree, that
is a **finding** you report, not something you quietly follow.

**Say what you actually ran.** A green test run is not a deployment. A skipped
required test did not pass. An interrupted external write is `unknown`, not
`failed` and not `0 created`.

**Stop conditions.** Three failed fix attempts → pause and escalate. No free
`BL-`/`TD-` id without a collision → do not mint the next free one. A dirty
working tree is not yours to commit. Production impact → contain or roll back first.

## Verification

Full verification runs **once, at the end**. Focused checks may run during work.
Report every result verbatim, including known failures. Do not summarise a failing
suite as "mostly passing".

Before claiming done, load `/verification-before-completion`.

## Diagrams

Prefer `/archify`: it validates geometry, proves desktop containment in a real
browser, and reports SHA-256 receipts. `/architecture-diagram` is the fallback when
shell or Node is unavailable — it has **no automated proof**, so state plainly that
your review was manual.

Specs go in `Knowledge/pm-os/canvas/`. Rendered files go in `Outputs/<Project>/`,
never into a note folder.

## Documentation is part of the change

One fact, every dependent document, two-way links, **in the same change**. Use
`/vault-note-update` for an existing fact and `/vault-note-creation` for a new
document. A deferred seam without an id is an incomplete change.

## When the framework and reality disagree

Report it. The framework was written for a specific product; parts of it will not
fit yours. Say which part, show the evidence, propose the smallest correction.
Do not silently follow stale text, and do not silently ignore it either.

