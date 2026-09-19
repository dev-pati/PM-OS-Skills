---
name: pk-ui-verify
description: Use when implementing or fixing frontend UI, layout, styling, interaction, or accessibility after the visual direction is known. Trace controls to their real consumers and verify the rendered result in a live browser. When the visual direction or design system is unresolved, use pk-ui-decide first.
license: Proprietary
metadata:
  version: "1.0"
  owner: PATI
  based_on: 03_agents/shared/agents/2026-09-14-pati-forge-design.md
---

# PATI UI Verify

Narrow scope: frontend visual/interaction/accessibility work, verified live.
Distilled from this workspace's recurring class of UI bugs that were
invisible from source alone — see `03_agents/shared/agents/hard-rules.md`.

## Scope

In scope: component markup/styling/layout, interaction wiring, accessibility,
and the browser-based verification of all of the above.

Out of scope: backend/data-layer changes beyond what's needed to wire a
control that already has a handler. When visual direction, palette, type,
layout system, or motion language is unresolved, load `pk-ui-decide` first.

## Hard rules

1. Start the dev server and exercise the actual change in a browser — golden
   path and edge cases — before reporting a UI change as done. Reading the
   diff is not verification for anything visual or interactive, and neither
   is a React/DevTools state trace — watching a state variable flip confirms
   the variable, not what the user actually sees change on screen.
2. A control having its own local state is not proof it has an effect. Trace
   the state through to the code path that actually consumes it (the
   handler, the route, the render branch) before declaring a toggle/button
   "works" — a wired-looking control can be a dead end if the consuming code
   still checks the old condition.
3. An element that must stay anchored to the viewport (sticky headers,
   floating toolbars, empty-state banners) must live outside any horizontally
   or vertically scrolling ancestor (e.g. outside a wide `<table>`), using
   `position: sticky`/fixed relative to the actual viewport — placed inside
   the scrolled container, it centers/anchors to the scroll width, not what
   the user sees. DevTools showing the CSS property applied, with no console
   errors, proves the rule matched — it does not prove which ancestor it
   anchors to; only scrolling the actual container in the browser shows that.
4. When a shared-looking JSX/CSS block repeats per row or per level (list
   item, table row, nested card), don't find/replace it by a snippet that
   matches more than one instance — anchor on the specific instance's unique
   surrounding context, or edit the read block directly, and confirm the
   edit landed in the intended instance only.
5. Before concluding an image/asset pipeline bug ("it's gray", "it's not
   loading"), check `naturalWidth`/an actual network response, not just that
   the `src` attribute looks right — `loading="lazy"` inside a hidden
   tab/modal can mean the browser never fetched it at all.
6. Don't trust the console/network panel's history across a navigation or
   server restart as current state — a stale error from before your fix can
   still be sitting in the buffer. Re-check against the live DOM or the file
   on disk before treating a console entry as a live bug.
7. Before moving, renaming, or repositioning a rendered element, grep for it
   in any contract/snapshot test that pins its literal text, class, or
   position — treat an unexpected red result as a signal to understand the
   pin's intent, not to force the change through by editing the test first.
8. Respect existing accessibility semantics (roles, labels, focus order)
   already present; don't remove or weaken them while touching adjacent
   markup for an unrelated visual change.

## Red flags — stop and verify live

- About to say a UI change "should work" without having opened it in the
  browser pane.
- About to declare a toggle/button functional because it renders and its
  local state changes, without tracing to the consumer.
- About to position a sticky/fixed element inside a scrollable container.
- About to find/replace a JSX/CSS snippet that appears more than once in the
  file without scoping to the specific instance.
