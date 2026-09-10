---
name: html-canvas
description: Build self-contained HTML proposal/brief canvases for AdLauncher using the app design system (Star Admin 2 Pro tokens, Manrope, light/dark, SVG-in-CSS-vars). Use when the user asks for HTML canvas, proposal page, CEO/MM brief, one-pager, architecture review HTML, options comparison page, or a visual decision doc that must open in a browser and match the app look. Not for production UI, Figma, or generic slide decks (use huashu-design for those).
---

# HTML Canvas

Self-contained HTML decision docs for stakeholders and engineers. One file. Open in browser. Looks like AdLauncher.

**Also installed globally** at `~/.claude/skills/html-canvas/` for org-wide use. This project copy wins when both exist (path conventions + AdLauncher references stay local).

**Reference implementation:** `Second Brain/Outputs/AdLauncher/specs/account-credential-infrastructure/account-infra-canvas.html` (full) and `account-infra-onepager.html` (1–2 page CEO scan). Prefer copying patterns from those over inventing new chrome.

## When to use which branch

| Signal | Branch | Length |
|---|---|---|
| CEO / MM / "quick scan" / "1–2 page" / non-technical | **One-pager** | 1–2 screenfuls |
| Architecture review, migration, options, DB sign-off, multi-section proposal | **Full canvas** | Numbered sections, as long as needed |
| Both | One-pager + full canvas, same folder, linked | — |

Default language = user's language. Code identifiers, table/column names, SQL, file paths stay English.

## Hard rules

1. **Evidence over assertion.** Numbers, counts, FK names, route names come from code/DB/docs. If unknown, say unknown — never invent KPIs or row counts.
2. **Options before recommendation.** When the page chooses among designs: show ≥2 real alternatives with pros/cons/cost first; verdict after. No rigged matrix that only A wins.
3. **Diagrams carry the claim.** Dual-lane flows, before/after trees, 3-panel option SVGs, ERDs — not walls of prose. Every critical distinction gets an SVG or table the eye can scan in 10s.
4. **App tokens only.** Colors, radius, shadows, type from Star Admin 2 Pro (`codebases/AdLauncher/app/globals.css`). No JetBrains Mono dark cyber theme (that is `/architecture-diagram`). No generic SaaS purple unrelated to the app.
5. **Self-contained.** One `.html`. Inline CSS. Google Fonts for Manrope only. No build step, no React, no external CSS. Theme toggle via `.dark` on `<html>`.
6. **Obsidian-readable location.** Write under `specs/<feature-slug>/`, never `.scratch/` (hidden) and never `src/` (wrong audience). Pair with a sibling `.md` only when the user asked for a durable AS-IS/spec write — the HTML is the scan surface.
7. **SVG rethemes.** Diagram fills/strokes/text use `var(--…)` so light/dark both work. No hard-coded `#1f3bb3` inside SVG attributes except when a marker fill must resolve at paint time via CSS `fill="var(--rose)"`.
8. **No metaphor vehicles.** State the system in its own words (VIA, slot, CASCADE, checkpoint). Drop "ambulance / car park" style analogies unless the user asks for them.
9. **Security copy is non-negotiable when credentials appear.** Never show raw tokens. Say where ciphertext lives, who can decrypt, what FE never receives.

## Process

### 1. Frame the audience and decision

- Who reads this (CEO/MM vs eng vs both)?
- What decision must they leave able to make?
- Full canvas or one-pager (or both)?

Completion: audience + decision + branch named.

### 2. Collect evidence (progressive)

Only what the page will state:
- Live counts / schema / FKs from Supabase or `Second Brain/.scratch/<project>/schema-dump-*` (e.g. `schema-dump-ads-launcher-20260810` under `.scratch/new-ads-launcher/`)
- Code seams (`rg` on the symbol, not the whole tree)
- Existing ADRs, runbooks, CONTEXT terms

Completion: every number/claim on the page has a source path or "unknown".

### 3. Outline sections before HTML

**One-pager skeleton:**
1. Title + one-sentence problem
2. 3–4 stats (real numbers only)
3. Before → after SVG
4. What we do in 3 steps
5. Decision ask (one line)

**Full canvas skeleton (adapt, don't force all):**
0. Executive summary + constraints confirmed
1. Scope / who is in the model
2. Critical distinction (often dual-lane SVG)
3. AS-IS (tree or ERD from real DB)
4. TO-BE (tree / model)
5. Options A/B/C with pros/cons/cost + visual compare + verdict
6. Database design (must be agree-able before code)
7. Runtime / switch / failover sequence
8. Security
9. Migration / runbook pointer
10. FE surfaces (if any)
11. Now vs later
12. Open decisions

Completion: outline approved by you (and user if scope is large). Then write HTML.

### 4. Build the HTML

1. Copy base chrome from `resources/base.css` patterns below (or from the reference files).
2. Write body sections. Prefer tables + SVG + short callouts over paragraphs.
3. For options: three `.opt` cards → comparison SVG or de-rigged matrix → `.verdict` with why + honest counter-argument + flip conditions.
4. Theme button top-right. Header gradient. Numbered `h2 .n`.
5. Save to `specs/<slug>/<name>.html`.

Completion: file opens locally, light/dark both readable, no horizontal body scroll (SVG may scroll inside `.dgwrap`).

### 5. Scrub before handoff

- [ ] No invented metrics
- [ ] Options shown before recommendation
- [ ] Residual wrong vocabulary removed (re-grep terms the user corrected)
- [ ] Column/table names match the design the page claims
- [ ] Sibling `architecture-review.md` / runbook linked if they exist
- [ ] Filename stable (redeploy same path if updating)

## Design system (copy these tokens)

Canonical source: `codebases/AdLauncher/app/globals.css`. Snapshot used by canvases:

```css
:root{
  --bg:#f4f5f7; --surface:#ffffff; --surface-2:#f4f5f7; --inset:#f2f4f7; --hover:#eef1f6;
  --line-soft:rgba(30,40,61,.08); --line-2:rgba(30,40,61,.05); --line-str:rgba(30,40,61,.15);
  --text-1:#1f1f1f; --text-2:#727788; --text-3:#a3a3a3;
  --brand-accent:#1f3bb3; --accent-soft:rgba(31,59,179,.08); --accent-line:rgba(31,59,179,.28);
  --grad:linear-gradient(135deg,#1f3bb3,#3a61f6);
  --emerald:#34b1aa; --amber:#e29e09; --rose:#f95f53;
  --sh:0 1px 2px rgba(30,40,61,.06); --sh-md:0 12px 32px -12px rgba(30,40,61,.18);
  --radius:0.5rem; --link:var(--brand-accent);
  --font-sans:"Manrope",ui-sans-serif,system-ui,-apple-system,"Segoe UI",sans-serif;
  --font-mono:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono",monospace;
}
.dark{
  color-scheme:dark;
  --bg:#1f2127; --surface:#252730; --surface-2:#2a2c36; --inset:#1b1d23; --hover:#2c2e38;
  --line-soft:rgba(255,255,255,.08); --line-2:rgba(255,255,255,.05); --line-str:rgba(255,255,255,.16);
  --text-1:#d8d9e3; --text-2:#9c9fa6; --text-3:#6b6d78;
  --brand-accent:#3a61f6; --accent-soft:rgba(58,97,246,.16); --accent-line:rgba(58,97,246,.4);
  --emerald:#3fbfb7; --amber:#f0aa2b; --rose:#fb6f63;
  --sh:0 1px 2px rgba(0,0,0,.3); --sh-md:0 12px 32px -12px rgba(0,0,0,.55);
  --link:#93b0ff;
}
```

Font load:

```html
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
```

Theme toggle:

```html
<button class="themebtn" onclick="document.documentElement.classList.toggle('dark')">◐ Light / Dark</button>
```

Full chrome (header, cards, tables, badges, tree, opts, SVG classes, callouts, steps): load [`resources/chrome.css`](resources/chrome.css) into the page's `<style>` block — do not link it as an external file at runtime; paste/inline so the HTML stays self-contained.

## Component patterns

| Need | Pattern |
|---|---|
| KPI strip | `.grid.g4` + `.stat` / `.stat.ok|.bad|.warn` |
| Risk row | `.risk` / `.risk.w` / `.risk.o` |
| Callout | `.callout` / `.callout.bad|.warn|.ok` |
| Hierarchy | `.treebox` + `.treechart` + `.tn.l0|.l1|.l2|.leaf|.stop|.sec` |
| Options | `.opts` > `.opt` (`.pick` on recommended) with `.pro`/`.con`/`.cost` |
| Verdict | `.verdict` after options, not before |
| Diagram | `.dgwrap` > `svg.dg` with classes `.bx` `.bx-new|.mod|.bad|.ok` `.ln` `.ln-ok|.bad|.w` `.hd` `.lb` `.t2` `.t3` |
| Sequence / steps | `ol.steps` |
| Code/SQL | `pre` with `.k` `.s` `.c` `.w` spans |
| Board compare | `.board` > `.slot` |

SVG hygiene:
- `viewBox` set; `min-width` on `svg.dg` (~900–1100) so it scrolls inside `.dgwrap` on narrow panes
- Markers for arrowheads use `fill="var(--rose)"` etc.
- Prefer elbow/bracket paths over diagonal lines that miss box centers
- Dual-lane flows: two horizontal lanes with shared start state when comparing recovery vs replace

## Options section (mandatory shape when recommending)

1. Heading: alternatives first ("Ba phương án — đặt cạnh nhau trước khi chọn")
2. Visual compare (3-panel SVG or honest matrix — include rows where the recommended option loses)
3. Three `.opt` cards: what / pro / con / cost
4. Callout correcting any prior misleading claim if this is a revision
5. `.verdict`: pick + 2–3 reasons + strongest counter-argument + flip-to-other conditions

Do not present a single "the plan" as if no alternative existed.

## One-pager constraints

- No DDL, no sequence diagrams, no 13-section TOC
- Max ~4 stats, 1 before/after SVG, 3 roadmap steps, 1 decision ask
- Still uses the same tokens and theme toggle
- May link to the full canvas for depth

## Out of scope

| Need | Use instead |
|---|---|
| Production app UI | Code in `codebases/AdLauncher/` |
| Dark cyber infra topology | `/architecture-diagram` |
| Hi-fi prototype / PPT / animation | `/huashu-design` |
| Durable AS-IS overwrite | `/vault-note-update` after the canvas is agreed |
| Migration procedure text | `runbooks/*.md` (canvas only points at it) |

## Completion criterion

Page opens as `file://`, answers the decision it was built for, every claim is sourced or marked unknown, light/dark both work, and — when options exist — the recommendation is impossible to read without first seeing the alternatives.
