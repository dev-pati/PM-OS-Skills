# Skill Map

Four validated Archify workflow diagrams covering the 76 skills in `catalog/`.
Each `.html` is self-contained; each `.workflow.json` is the editable source.

| Diagram | Group | Skills | Entry point |
|---|---|---|---|
| [design-ui.html](design-ui.html) | `catalog/design` + UI-adjacent `pk-` | 21 | `DS-ui-skills-root` |
| [mattpocock-vibecoding.html](mattpocock-vibecoding.html) | `catalog/mattpocock` | 25 | `mpc-ask-matt` |
| [pati-delivery.html](pati-delivery.html) | `catalog/pati` delivery + security + data | 14 | `pk-build-connected` |
| [knowledge-core-loop.html](knowledge-core-loop.html) | `catalog/pati` knowledge + `catalog/core` | 16 | `brainstorming` / `pk-user-research` |

Swimlanes are workflow stages; the bold main path is the default route and
branch labels state the condition that selects a side skill.

## Regenerate

```bash
cd catalog/pati/pk-architecture-diagram
node bin/archify.mjs deliver workflow <source>.workflow.json <out>.html --quality showcase --json
```

## Prefixes

| Prefix | Origin |
|---|---|
| `DS-` | ui-skills.com registry (design engineering) |
| `mpc-` | Matt Pocock engineering skills |
| `pk-` | PATI-authored or adapted |
| no prefix | superpowers core loop |

