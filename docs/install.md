# What the installer does

```bash
./install.sh <workspace-path>
```

Idempotent. Run it again to update.

## Steps

1. **Find or create the vault.** Looks for `Second Brain/`, `second-brain/`,
   `vault/`, `SECOND-BRAIN/`. Creates `Second Brain/` if none exists.
2. **Copy the framework** → `Knowledge/pm-os/`, canvas specs → `Knowledge/pm-os/canvas/`,
   rendered HTML → `Outputs/pm-os/`.
3. **Create missing vault folders** only. Existing ones are left alone.
4. **Copy skills** → `Skills/<domain>/`.
5. **Link skills** by running `Skills/meta/sync-links.sh`: builds `Skills/_flat/`
   then symlinks it to `.claude/skills` and `.agents/skills` at the root and in
   every real directory under `codebases/`.
6. **Write the AGENTS.md block.**
7. **Stamp** `.pm-os-version` with version and date.

## The AGENTS.md rule

| Situation | What happens |
|---|---|
| No `AGENTS.md` | Created with a heading and the pm-os block |
| Exists, no pm-os markers | Block **appended** at the end. Nothing else changes |
| Exists, has pm-os markers | Only the text **between the markers** is replaced |

Write your own rules outside `<!-- pm-os:start -->` … `<!-- pm-os:end -->` and they
survive every update. `CLAUDE.md` gets the same treatment if it already exists.

## What it never touches

- Anything inside `codebases/*/` except creating `.claude/skills` and
  `.agents/skills` symlinks. No repo file is read or written.
- Existing vault notes outside `Knowledge/pm-os/` and `Outputs/pm-os/`.
- Your text outside the pm-os block.
- Git state. It does not commit, stage, or branch.

## What it does overwrite

- Everything in `Knowledge/pm-os/` and `Outputs/pm-os/`.
- A skill with the same name in the same domain. If you edited
  `Skills/product/grilling/SKILL.md` in place, that edit is lost. Fork under a new
  name instead.
- `Skills/_flat/` is deleted and rebuilt every run. It is generated; never edit it.

## Failure modes

| Symptom | Cause | Fix |
|---|---|---|
| `real folder at …/.claude/skills` | A real directory sits where the symlink goes | Move its contents into `Skills/<domain>/`, delete the folder, re-run |
| `duplicate skill name: x` | Two domains define the same skill name | Rename one. Skill names are globally unique |
| `sync-links.sh failed` | See `/tmp/pmos-sync.log` | Usually the two rows above |
| `node not found` | Node is not installed | Framework still installs; `/archify` cannot render |

## Verify an install

```bash
cat <ws>/.pm-os-version
ls "<ws>/Second Brain/Knowledge/pm-os"
ls -l "<ws>/.claude/skills"                 # symlink -> Skills/_flat
head -3 "<ws>/.claude/skills/build-connected/SKILL.md"
grep -c 'pm-os:start' <ws>/AGENTS.md        # expect 1
```

## Uninstall

There is no uninstaller. To remove by hand: delete `Knowledge/pm-os/`,
`Outputs/pm-os/`, `.pm-os-version`, the pm-os block in `AGENTS.md`, and the
29 skill folders. Skills you added yourself are unaffected.

