#!/usr/bin/env bash
# macOS/Linux twin of sync-junctions.ps1.
#   Second Brain/Skills/<domain>/<skill>/SKILL.md   canonical
#   Second Brain/Skills/_flat/<skill>               symlink -> canonical
#   <consumer>/.claude/skills, <consumer>/.agents/skills   symlink -> Skills/_flat
# Consumers: workspace root and every dir under codebases/.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; WS="$(cd "$ROOT/../.." && pwd)"; FLAT="$ROOT/_flat"
HIDDEN="$ROOT/meta/hidden-default.txt"
rm -rf "$FLAT"; mkdir -p "$FLAT"; n=0
for d in "$ROOT"/*/; do dn=$(basename "$d"); [ "$dn" = "_flat" ] && continue
  for s in "$d"*/; do [ -f "$s/SKILL.md" ] || continue; sn=$(basename "$s")
    [ -f "$HIDDEN" ] && grep -Fqx "$sn" "$HIDDEN" && continue
    [ -e "$FLAT/$sn" ] && { echo "duplicate skill name: $sn" >&2; exit 1; }
    ln -s "$s" "$FLAT/$sn"; n=$((n+1)); done; done
c=0
# Only real directories become consumers; an unmatched glob must not create one.
consumers=("$WS")
for cand in "$WS"/codebases/*/; do [ -d "$cand" ] && consumers+=("$cand"); done
for consumer in "${consumers[@]}"; do
  for a in .claude .agents; do j="$consumer/$a/skills"
    if [ -e "$j" ] && [ ! -L "$j" ]; then echo "real folder at $j — move it into skills/<domain>/ first" >&2; exit 1; fi
    mkdir -p "$consumer/$a"; ln -sfn "$FLAT" "$j"; c=$((c+1)); done; done
echo "flat: $n skills · consumers: $c links"
