# Adapting this to a workspace that is not PATI

The framework encodes real decisions from one product. Some of it is universal,
some is not. Here is the split.

## Portable as-is

- The two-gate structure, and that parking is a success.
- Evidence precedence: `runtime > commit > chat > none`.
- Stop conditions: three attempts, no id-minting, dirty tree, contain-before-diagnose.
- "Shipped is not adopted."
- The Linear loop shape: seven stages, three human gates, one thread.
- Every skill in `skills/` except the vault-specific ones noted below.

## Needs rewriting for your product

| Thing | Why it is PATI-specific |
|---|---|
| `BL-` / `TD-` ledgers | Backlog and tech-debt id schemes with real collision history |
| The eight KPIs in Gate 1 B4 | AdLauncher's KPI set |
| `W` lane names in Gate 2 plane 1 | Comes from `architecture/bpmn.canvas` in the PATI vault |
| Ghost-ads ordering rule | Bought by a specific Meta incident on 25/08/2026 |
| Meta / Supabase / R2 boundaries | Product integrations |
| `vault-*` skills | Assume the PATI vault folder contract in `AGENTS.md` §1–§3 |

The worked incident in `product-development-framework.md` §10 is deliberately
concrete. Keep the **shape** — measure, then correct, then buy a structural rule —
and replace the content with your own postmortem.

## Minimum adaptation

1. Install, then read `Knowledge/pm-os/product-development-framework.md` end to end.
2. Replace the KPI list in Gate 1 B4 with yours.
3. Replace the ledger prefixes, or point them at your tracker's id scheme.
4. Delete the plane-1 lane names until you have a process map to point at.
5. Keep Gate 2's reverse trace. It is the step every team skips and every team regrets.

## Vendoring archify

Archify is not bundled — it is ~3 MB with `renderers/`, `test/`, `bin/`.
Three options:

| Option | Trade-off |
|---|---|
| Leave it at `~/.agents/skills/archify/` | Repo stays small. Every machine installs it separately |
| Vendor into `skills/documentation/archify/` | One install gets everything. Repo grows, and a vault that only allows `.md`/`.canvas` now holds JS |
| Git submodule | Small repo, pinned version, one extra clone step |

Current choice: **leave it outside**, and the installer warns when `node` is missing.

## Skills you will probably drop

`vault-knowledge-retrieval`, `vault-note-creation`, `vault-note-update` and
`vault-system-thinking` all assume the PATI vault layout. If your knowledge layer
is different, either rewrite the paths inside them or drop them and keep the gates.

## Skills deliberately excluded

The PATI library has 59 skills. This repo ships 29. Left out on purpose:
`lark-*` (30+ Lark tool skills), `supabase`, `react-best-practices`,
`e2e-testing`, `threat-model`, `ui-ux-pro-max`, `daily-app-status`, and the
rest of `superpowers/`. They are good, but they are stack choices, not the framework.

