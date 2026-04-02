#!/usr/bin/env bash
set -euo pipefail

K8S_ROOT="${K8S_ROOT:-$HOME/nixos/k8s}"

clusters_dir="$K8S_ROOT/clusters"
if [ ! -d "$clusters_dir" ]; then
  echo "No clusters directory: $clusters_dir"
  exit 1
fi

for cluster in "$clusters_dir"/*; do
  [ -d "$cluster" ] || continue
  cluster_name="$(basename "$cluster")"
  apps_dir="$cluster/apps"
  if [ ! -d "$apps_dir" ]; then
    echo "$cluster_name: (no apps)"
    continue
  fi
  apps=$(find "$apps_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f ' | sed 's/ $//')
  if [ -z "$apps" ]; then
    echo "$cluster_name: (no apps)"
  else
    echo "$cluster_name: $apps"
  fi
done
