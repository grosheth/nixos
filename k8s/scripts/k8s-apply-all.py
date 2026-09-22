#!/usr/bin/env python3
"""Apply every enabled app and remove resources absent from the desired set."""

import json
import os
from pathlib import Path
import subprocess
import sys


ROOT = Path(os.environ.get("K8S_ROOT", str(Path.home() / "nixos/k8s")))
INVENTORY_NAME = "k8s-apply-inventory"
INVENTORY_NAMESPACE = "default"
BOOTSTRAP_KINDS = (
    "deployments,statefulsets,daemonsets,services,ingresses,"
    "configmaps,secrets,jobs,cronjobs"
)


def run(*args, input_text=None):
    result = subprocess.run(args, input=input_text, text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError(f"{' '.join(map(str, args))}: {result.stderr.strip()}")
    return result.stdout


def objects(text):
    decoder = json.JSONDecoder()
    result = []
    while text.strip():
        text = text.lstrip()
        obj, end = decoder.raw_decode(text)
        result.extend(obj.get("items", []) if obj.get("kind") == "List" else [obj])
        text = text[end:]
    return result


def identity(obj, default_namespace="default"):
    metadata = obj["metadata"]
    kind = obj["kind"]
    namespace = "" if kind == "Namespace" else metadata.get("namespace") or default_namespace
    api_version = obj["apiVersion"]
    group = api_version.split("/", 1)[0] if "/" in api_version else ""
    return (group, kind, namespace, metadata["name"])


def config(conf):
    output = run(
        "bash", "-c", 'set -a; source "$1"; env -0', "bash", str(conf)
    )
    values = dict(item.split("=", 1) for item in output.split("\0") if "=" in item)
    return values


def path_for(app_dir, value):
    path = Path(value)
    return path if path.is_absolute() else app_dir / path


def rendered(app_dir, values):
    method = values.get("METHOD")
    if method == "raw":
        path = path_for(app_dir, values.get("MANIFESTS_PATH", "manifests"))
        text = run("kubectl", "create", "--dry-run=client", "--validate=false", "-o", "json", "-f", str(path))
    elif method == "kustomize":
        path = path_for(app_dir, values.get("KUSTOMIZE_PATH", "kustomize"))
        manifest = run("kubectl", "kustomize", str(path))
        text = run("kubectl", "create", "--dry-run=client", "--validate=false", "-o", "json", "-f", "-", input_text=manifest)
    else:
        raise ValueError(f"Unknown METHOD in {app_dir / 'app.conf'}: {method}")
    return [identity(obj, values.get("NAMESPACE", "default")) for obj in objects(text)]


def inventory():
    text = run("kubectl", "get", "configmap", INVENTORY_NAME, "-n", INVENTORY_NAMESPACE, "--ignore-not-found", "-o", "json")
    if not text.strip():
        return None
    data = json.loads(text)["data"]
    return {
        "resources": {tuple(item) for item in json.loads(data.get("resources.json", "[]"))},
        "helm": {tuple(item) for item in json.loads(data.get("helm.json", "[]"))},
    }


def bootstrap(app_names):
    found = set()
    for app in app_names:
        text = run("kubectl", "get", BOOTSTRAP_KINDS, "-A", "-l", f"app={app}", "-o", "json")
        for obj in objects(text):
            annotations = obj.get("metadata", {}).get("annotations", {})
            if "kubectl.kubernetes.io/last-applied-configuration" in annotations:
                found.add(identity(obj))
    return found


def save_inventory(resources, helm):
    obj = {
        "apiVersion": "v1",
        "kind": "ConfigMap",
        "metadata": {"name": INVENTORY_NAME, "namespace": INVENTORY_NAMESPACE},
        "data": {
            "resources.json": json.dumps(sorted(resources)),
            "helm.json": json.dumps(sorted(helm)),
        },
    }
    print(run("kubectl", "apply", "-f", "-", input_text=json.dumps(obj)), end="")


def main():
    if len(sys.argv) != 1:
        raise ValueError("Usage: k8s-apply-all")
    namespaces_dir = ROOT / "namespaces"
    if not namespaces_dir.is_dir():
        raise ValueError(f"No namespaces directory: {namespaces_dir}")
    configs = sorted(namespaces_dir.glob("*/apps/*/app.conf"))

    desired = set()
    desired_helm = set()
    apps = []
    app_names = []
    for conf in configs:
        app_dir = conf.parent
        app = app_dir.name
        directory_namespace = app_dir.parent.parent.name
        values = config(conf)
        if values.get("ENABLED", "true") == "false":
            continue
        method = values.get("METHOD")
        if method == "helm":
            release = values.get("RELEASE")
            if not release or release == "REPLACE_ME":
                raise ValueError(f"Missing RELEASE in {conf}")
            desired_helm.add((values.get("NAMESPACE", "default"), release))
        else:
            for resource in rendered(app_dir, values):
                if resource in desired:
                    raise ValueError(f"Resource declared twice: {resource}")
                desired.add(resource)
            app_names.append(app)
        apps.append((directory_namespace, app))

    previous = inventory()
    prior_resources = previous["resources"] if previous else bootstrap(app_names)
    prior_helm = previous["helm"] if previous else set()

    for namespace, app in apps:
        print(f"Applying {namespace}/{app}", flush=True)
        print(run("bash", str(ROOT / "scripts/k8s-apply.sh"), namespace, app), end="", flush=True)

    stale = prior_resources - desired
    for group, kind, old_namespace, name in sorted(stale):
        if kind == "Namespace":
            continue
        moved = [item for item in desired if item[0] == group and item[1] == kind and item[3] == name and item[2] != old_namespace]
        if kind in {"Deployment", "StatefulSet", "DaemonSet"}:
            for _, _, new_namespace, _ in moved:
                print(run("kubectl", "rollout", "status", f"{kind.lower()}/{name}", "-n", new_namespace, "--timeout=120s"), end="")
        resource_type = f"{kind.lower()}.{group}" if group else kind.lower()
        print(run("kubectl", "delete", resource_type, name, "-n", old_namespace, "--ignore-not-found"), end="")

    for namespace, release in sorted(prior_helm - desired_helm):
        print(run("helm", "uninstall", release, "-n", namespace), end="")

    for _, kind, _, name in sorted(stale):
        if kind != "Namespace":
            continue
        if name in {"default", "kube-system", "kube-public", "kube-node-lease"}:
            raise ValueError(f"Refusing to delete system namespace: {name}")
        if any(resource[2] == name for resource in desired) or any(release[0] == name for release in desired_helm):
            raise ValueError(f"Refusing to delete namespace still used by an app: {name}")
        print(run("kubectl", "delete", "namespace", name, "--ignore-not-found"), end="")

    save_inventory(desired, desired_helm)


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, ValueError, OSError, KeyError, json.JSONDecodeError) as error:
        print(f"k8s-apply-all: {error}", file=sys.stderr)
        sys.exit(1)
