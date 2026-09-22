#!/usr/bin/env bash
set -euo pipefail

K8S_ROOT="${K8S_ROOT:-$HOME/nixos/k8s}"
exec python3 "$K8S_ROOT/scripts/k8s-apply-all.py" "$@"
