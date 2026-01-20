# helm-argo-events

A Crossplane Configuration package that installs the Argo Events Helm chart with a minimal, stable interface.

## Overview

`helm-argo-events` renders a single Helm release for Argo Events. It exposes only the inputs needed
for chart values, namespace, and release name, keeping the interface stable while allowing full Helm overrides.

Argo Events is an event-driven workflow automation framework for Kubernetes that provides event sources, sensors, and triggers to build event-driven architectures.

## Features

- **Minimal Helm interface**: values and overrideAllValues with stable defaults
- **Predictable naming**: defaults to resource name in the `argo-events` namespace
- **CRDs managed**: installs and keeps CRDs by default
- **GitOps friendly**: ships a `.gitops/` deploy chart

## Prerequisites

- Crossplane installed in the cluster
- Crossplane providers:
  - `provider-helm` (>=v1.0.6)
- Crossplane function:
  - `function-auto-ready` (>=v0.6.0)

## Quick Start

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Configuration
metadata:
  name: helm-argo-events
spec:
  package: ghcr.io/hops-ops/helm-argo-events:latest
```

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: ArgoEvents
metadata:
  name: argo-events
  namespace: default
spec:
  clusterName: my-cluster
```

## Configuration Options

### Minimal

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: ArgoEvents
metadata:
  name: argo-events
  namespace: default
spec:
  clusterName: my-cluster
```

### With Custom Values

```yaml
apiVersion: helm.hops.ops.com.ai/v1alpha1
kind: ArgoEvents
metadata:
  name: argo-events
  namespace: default
spec:
  clusterName: production-cluster
  namespace: argo-events
  labels:
    team: platform
    environment: production
  providerConfigRef:
    name: production-cluster
    kind: ProviderConfig
  values:
    controller:
      replicas: 2
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
```

## Status

The XRD exposes the following status fields:

| Field | Description |
|-------|-------------|
| `ready` | Overall readiness of the ArgoEvents installation |
| `release.name` | Name of the Helm release |
| `release.namespace` | Namespace of the Helm release |
| `release.ready` | Whether the Helm release is ready |

## Development

```bash
make render      # Render all examples
make validate    # Validate all examples
make test        # Run unit tests
make e2e         # Run E2E tests
```

## License

Apache-2.0
