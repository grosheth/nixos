# k8s deployments

This folder holds per-cluster Kubernetes deployments with mixed install methods
(raw manifests, kustomize, helm). Home Manager only installs helper commands; it
never runs kubectl/helm during activation.

## Commands

- `k8s-apply <cluster> <app>`
- `k8s-diff <cluster> <app>`
- `k8s-render <cluster> <app>`

## Structure

```
k8s/
  clusters/<cluster>/apps/<app>/app.conf
  clusters/<cluster>/apps/<app>/manifests/  # raw
  clusters/<cluster>/apps/<app>/kustomize/  # kustomize
  clusters/<cluster>/apps/<app>/values.yaml # helm values (optional)
```

## app.conf

`app.conf` is a simple shell file. Example for Helm:

```
METHOD=helm
NAMESPACE=ibm-mq
RELEASE=ibm-mq
REPO_NAME=REPLACE_ME
REPO_URL=REPLACE_ME
CHART=REPLACE_ME
VALUES=values.yaml
```

Use `METHOD=raw` or `METHOD=kustomize` and point to paths with
`MANIFESTS_PATH` or `KUSTOMIZE_PATH` if you want custom locations.
