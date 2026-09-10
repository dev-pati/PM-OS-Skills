#!/usr/bin/env bash
# pati-pm-os installer. Idempotent: run again to update.
#
#   ./install.sh <workspace-path>
#
# Copies framework, skills, canvas specs and rendered outputs into the workspace
# vault, links skills into every agent runtime, and writes the pm-os block into
# AGENTS.md without touching anything you wrote yourself.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS="${1:-}"
VERSION="$(cat "$SRC/VERSION")"
TODAY="$(date -u "+%Y-%m-%d")"

die()  { printf "pm-os: %s\n" "$1" >&2; exit 1; }
note() { printf "  %s\n" "$1"; }

[ -n "$WS" ] || die "usage: ./install.sh <workspace-path>"
WS="$(cd "$WS" 2>/dev/null && pwd)" || die "no such directory"
[ "$WS" != "$SRC" ] || die "refusing to install into the source repo"

# --- locate or create the vault ---
VAULT=""
for cand in "Second Brain" "second-brain" "vault" "SECOND-BRAIN"; do
  if [ -d "$WS/$cand" ]; then VAULT="$WS/$cand"; break; fi
done
if [ -z "$VAULT" ]; then
  VAULT="$WS/Second Brain"
  note "creating vault at Second Brain/"
  mkdir -p "$VAULT"
fi

PMOS="$VAULT/Knowledge/pm-os"
printf "pm-os %s -> %s\n" "$VERSION" "$WS"

# --- 1. framework, canvas, docs, outputs ---
mkdir -p "$PMOS/canvas" "$VAULT/Outputs/pm-os"
cp "$SRC/framework/"*.md "$PMOS/"
cp "$SRC/canvas/"* "$PMOS/canvas/"
cp "$SRC/docs/"*.md "$PMOS/" 2>/dev/null || true
cp "$SRC/outputs/"*.html "$VAULT/Outputs/pm-os/" 2>/dev/null || true
note "framework  -> Knowledge/pm-os/"
note "canvas     -> Knowledge/pm-os/canvas/"
note "outputs    -> Outputs/pm-os/"

# --- 2. vault skeleton, only what is missing ---
created=0
for d in Projects Specs Decisions Research Knowledge Meetings Outputs System Skills; do
  if [ ! -d "$VAULT/$d" ]; then mkdir -p "$VAULT/$d"; created=$((created+1)); fi
done
if [ "$created" -gt 0 ]; then note "vault      -> created $created missing folder(s)"; fi

# --- 3. skills ---
SK="$VAULT/Skills"
mkdir -p "$SK"
for dom in "$SRC"/skills/*/; do
  d="$(basename "$dom")"
  mkdir -p "$SK/$d"
  cp -R "$dom." "$SK/$d/"
done
n_sk="$(find "$SRC/skills" -name SKILL.md | wc -l | tr -d " ")"
note "skills     -> Skills/ ($n_sk skills)"

# --- 4. link skills into agent runtimes ---
if [ -f "$SK/meta/sync-links.sh" ]; then
  if bash "$SK/meta/sync-links.sh" >/tmp/pmos-sync.log 2>&1; then
    note "links      -> $(tail -1 /tmp/pmos-sync.log)"
  else
    note "links      -> sync-links.sh failed, see /tmp/pmos-sync.log"
  fi
fi

# --- 5. AGENTS.md ---
REL_PMOS="${PMOS#$WS/}"
BLOCK="$(sed -e "s|__PMOS_VERSION__|$VERSION|g" -e "s|__PMOS_DATE__|$TODAY|g" -e "s|__PMOS_PATH__|$REL_PMOS|g" "$SRC/templates/AGENTS.md.tmpl")"
export PMOS_BLOCK="$BLOCK"

write_block() {
  target="$1"; label="$2"
  if [ ! -f "$target" ]; then
    { printf "# %s\n\n" "$label"; printf "%s\n" "$BLOCK"; } > "$target"
    note "$(basename "$target")  -> created"
    return
  fi
  if grep -q "pm-os:start" "$target"; then
    PMOS_TARGET="$target" python3 "$SRC/templates/patch-block.py"
    note "$(basename "$target")  -> pm-os block updated, your content untouched"
  else
    printf "\n%s\n" "$BLOCK" >> "$target"
    note "$(basename "$target")  -> pm-os block appended"
  fi
}

write_block "$WS/AGENTS.md" "Workspace agent contract"
if [ -f "$WS/CLAUDE.md" ]; then write_block "$WS/CLAUDE.md" "Workspace agent contract"; fi

# --- 6. stamp ---
printf "%s\n%s\n" "$VERSION" "$TODAY" > "$WS/.pm-os-version"

# --- 7. report ---
printf "\ndone. next:\n"
printf "  1. read %s/pm-operating-system.md\n" "$REL_PMOS"
printf "  2. open Outputs/pm-os/pm-operating-system-archify.html\n"
printf "  3. re-run this installer any time to update\n"
if ! command -v node >/dev/null 2>&1; then
  printf "\nnote: node not found. /archify cannot run; diagrams fall back to hand-placed SVG.\n"
fi

