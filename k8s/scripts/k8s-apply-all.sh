#!/usr/bin/env bash
set -euo pipefail

K8S_ROOT="${K8S_ROOT:-$HOME/nixos/k8s}"

if [ "$#" -ne 0 ]; then
  echo "Usage: k8s-apply-all"
  exit 1
fi

if [ ! -d "$K8S_ROOT/namespaces" ]; then
  echo "No namespaces directory: $K8S_ROOT/namespaces"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$script_dir/k8s-apply.sh" ]; then
  apply_command=(bash "$script_dir/k8s-apply.sh")
else
  apply_command=(k8s-apply)
fi

found=false
for conf in "$K8S_ROOT"/namespaces/*/apps/*/app.conf; do
  [ -f "$conf" ] || continue
  found=true
  app="$(basename "$(dirname "$conf")")"
  namespace="$(basename "$(dirname "$(dirname "$(dirname "$conf")")")")"
  echo "Applying $namespace/$app"
  "${apply_command[@]}" "$namespace" "$app"
done

if [ "$found" = false ]; then
  echo "No applications found under $K8S_ROOT/namespaces"
  exit 1
fi
