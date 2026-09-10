# product/

Purpose: decide *whether* and *what* before anything is built. Every build starts here.

| Skill | Load when |
|---|---|
| `build-connected` | Any "build / add / implement / ship" request. Runs the two gates, then chains the rest. |
| `grilling` | Plan or idea needs stress-testing; one question at a time. |
| `grill-with-docs` | Same, but terminology is fuzzy — leaves ADRs + glossary in `CONTEXT.md`. |
| `domain-modeling` | Pin a term, resolve an overloaded word, record a decision. |
| `to-spec` | Conversation is done; publish it as a spec on the tracker. |
| `vault-system-thinking` | Before building or documenting any change — Impact Trace across 8 planes. |

Combos: feature → `build-connected` (which calls `grilling` → `domain-modeling` → `vault-system-thinking` → `to-spec` → `delivery/to-tickets`). Idea only → `grilling` → `to-questionnaire` if the decision belongs to someone else.

Not here: prioritisation math (RICE/CoD) lives in vault `product/backlog.md`; PRD template is the vault `src/<feature>/PRD/PRD.md` slot via `documentation/vault-note-creation`.
