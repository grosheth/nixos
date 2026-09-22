# Kubernetes deployments

This directory contains applications grouped by namespace. Each application has an
`app.conf` that selects raw manifests, Kustomize, or Helm. The helper commands are
installed by Home Manager, but Home Manager does not deploy these applications.

## Using the helpers

The commands use `K8S_ROOT` (default: `$HOME/nixos/k8s`) to find applications.
Home Manager sets this variable and `KUBECONFIG` for this setup. Ensure `kubectl`
and, for Helm applications, `helm` are available and point at the intended cluster
before using commands that contact it.

```sh
k8s-list                         # list namespace and application directories
k8s-render default hello-world   # print the rendered resources
k8s-diff default hello-world     # compare with the cluster
k8s-apply default hello-world    # deploy
k8s-delete default hello-world   # remove resources
```

`k8s-render` uses a client-side dry run for raw manifests, `kubectl kustomize` for
Kustomize, and `helm template` for Helm. `k8s-diff` uses `kubectl diff`; a nonzero
exit status can mean that differences were found. `k8s-delete` removes the
application resources (or uninstalls its Helm release), so review the target
before running it.

## Applications

| Directory | Method | Notes |
| --- | --- | --- |
| `namespaces/default/apps/hello-world` | Raw | An nginx Deployment and ClusterIP Service. |
| `namespaces/mq/apps/activemq-artemis` | Raw | Creates the `mq` namespace, a broker StatefulSet with a 5 Gi volume claim, Services, and a Traefik Ingress for `artemis.local`. Replace the example credentials in `manifests/secret.yaml` before deploying. |
| `namespaces/mq/apps/ibm-mq` | Helm | Template only: fill in the repository, chart, and values before use. Its `app.conf` currently sets the Helm target namespace to `ibm-mq`. |

## Adding an application

Create `namespaces/<namespace>/apps/<app>/app.conf`. This is a shell file sourced
by the helpers. Set `METHOD` to `raw`, `kustomize`, or `helm`:

```sh
# Raw manifests in the default app-relative manifests/ directory
METHOD=raw
```

For raw manifests, `MANIFESTS_PATH` can override `manifests/`. For Kustomize,
`KUSTOMIZE_PATH` can override `kustomize/`. These paths may be absolute or
relative to the application directory.

For Helm, set `RELEASE` and `CHART`. Optionally set `NAMESPACE` (defaults to
`default`) and `VALUES` (space-separated paths relative to the application
directory). If using a chart repository, set both `REPO_NAME` and `REPO_URL`;
the helpers add and update that repository before rendering, diffing, or
applying. Helm apply creates the target namespace if needed.

```sh
METHOD=helm
NAMESPACE=example
RELEASE=example
REPO_NAME=example
REPO_URL=https://example.com/charts
CHART=example
VALUES=values.yaml
```

The directory namespace selects which `app.conf` to load. For Helm, the
`NAMESPACE` value in that file selects the deployment namespace.
