#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$repo_dir/configs/quickshell/medieval"

case "${1:-start}" in
  start) ;;
  stop)
    qs kill -p "$config_dir" --any-display >/dev/null 2>&1 || true
    gallery-ui-reload
    exit 0
    ;;
  *)
    printf 'Usage: %s [start|stop]\n' "$0" >&2
    exit 2
    ;;
esac

# Stop the gallery's workspace wallpaper changer before showing the new set.
for config in gallery-transition gallery-status gallery-signature; do
  qs kill -c "$config" --any-display >/dev/null 2>&1 || true
done

# Remove the gallery images still held by the wallpaper daemon.
awww clear >/dev/null 2>&1 || true

qs -d -n -p "$config_dir"
