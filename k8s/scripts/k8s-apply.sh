#!/usr/bin/env bash
set -euo pipefail

K8S_ROOT="${K8S_ROOT:-$HOME/nixos/k8s}"

usage() {
  echo "Usage: k8s-apply <cluster> <app>"
}

if [ "$#" -ne 2 ]; then
  usage
  exit 1
fi

cluster="$1"
app="$2"
app_dir="$K8S_ROOT/clusters/$cluster/apps/$app"
conf="$app_dir/app.conf"

if [ ! -f "$conf" ]; then
  echo "Missing app config: $conf"
  exit 1
fi

# shellcheck disable=SC1090
source "$conf"

require_var() {
  local name="$1"
  local value="${!name:-}"
  if [ -z "$value" ] || [ "$value" = "REPLACE_ME" ]; then
    echo "Config error: $name is not set in $conf"
    exit 1
  fi
}

METHOD="${METHOD:-}"
if [ -z "$METHOD" ]; then
  echo "Config error: METHOD is not set in $conf"
  exit 1
fi

case "$METHOD" in
  helm)
    require_var RELEASE
    require_var CHART
    namespace="${NAMESPACE:-default}"

    chart_ref="$CHART"
    if [ -n "${REPO_NAME:-}" ] || [ -n "${REPO_URL:-}" ]; then
      require_var REPO_NAME
      require_var REPO_URL
      helm repo add "$REPO_NAME" "$REPO_URL" >/dev/null
      helm repo update "$REPO_NAME" >/dev/null
      chart_ref="$REPO_NAME/$CHART"
    fi

    values_args=()
    if [ -n "${VALUES:-}" ]; then
      for v in $VALUES; do
        values_args+=( -f "$app_dir/$v" )
      done
    fi

    helm upgrade --install "$RELEASE" "$chart_ref" \
      -n "$namespace" --create-namespace \
      "${values_args[@]}"
    ;;
  kustomize)
    path="${KUSTOMIZE_PATH:-$app_dir/kustomize}"
    kubectl apply -k "$path"
    ;;
  raw)
    path="${MANIFESTS_PATH:-$app_dir/manifests}"
    kubectl apply -f "$path"
    ;;
  *)
    echo "Unknown METHOD: $METHOD"
    exit 1
    ;;
 esac
