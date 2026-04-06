#!/usr/bin/env bash
set -euo pipefail

K8S_ROOT="${K8S_ROOT:-$HOME/nixos/k8s}"

namespaces_dir="$K8S_ROOT/namespaces"
if [ ! -d "$namespaces_dir" ]; then
  echo "No namespaces directory: $namespaces_dir"
  exit 1
fi

for namespace in "$namespaces_dir"/*; do
  [ -d "$namespace" ] || continue
  namespace_name="$(basename "$namespace")"
  apps_dir="$namespace/apps"
  if [ ! -d "$apps_dir" ]; then
    echo "$namespace_name: (no apps)"
    continue
  fi
  apps=$(find "$apps_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f ' | sed 's/ $//')
  if [ -z "$apps" ]; then
    echo "$namespace_name: (no apps)"
  else
    echo "$namespace_name: $apps"
  fi
done
