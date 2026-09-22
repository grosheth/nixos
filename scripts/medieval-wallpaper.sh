#!/usr/bin/env bash
set -euo pipefail

script_path="$(readlink -f -- "${BASH_SOURCE[0]}")"
repo_dir="$(cd -- "$(dirname -- "$script_path")/.." && pwd)"
config_dir="$repo_dir/configs/quickshell/medieval"
wallpaper_file="$repo_dir/assets/hyprland/Medieval/castle.png"

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

if [[ ! -f "$wallpaper_file" ]]; then
  printf 'Wallpaper not found: %s\n' "$wallpaper_file" >&2
  exit 1
fi

export MEDIEVAL_WALLPAPER_URL="file://$wallpaper_file"

# Stop the gallery's workspace wallpaper changer before showing the new set.
for config in gallery-transition gallery-status gallery-signature; do
  qs kill -c "$config" --any-display >/dev/null 2>&1 || true
done

# Remove the gallery images still held by the wallpaper daemon.
awww clear >/dev/null 2>&1 || true

qs kill -p "$config_dir" --any-display >/dev/null 2>&1 || true
qs -d -n -p "$config_dir"
