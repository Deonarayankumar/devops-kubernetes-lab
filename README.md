# DevOps Kubernetes Lab

Kubernetes manifests with Kustomize overlays for dev and staging environments.

## Prerequisites

- kubectl 1.28+
- A cluster (minikube, kind, AKS, or EKS)
- kustomize 5.x (built into kubectl)

## Quick start

```bash
# Dev overlay
kubectl apply -k k8s/overlays/dev
./scripts/smoke-test.sh dev

# Staging overlay
kubectl apply -k k8s/overlays/staging
./scripts/smoke-test.sh staging
```

## Layout

| Path | Purpose |
|------|---------|
| `k8s/base/` | Base Deployment, Service, Ingress, ConfigMap |
| `k8s/overlays/dev/` | Dev replicas and image tag |
| `k8s/overlays/staging/` | Staging replicas and ingress host |
| `docs/` | Troubleshooting runbooks |
| `scripts/` | Post-deploy smoke tests |

## Troubleshooting

- [CrashLoopBackOff runbook](docs/runbook-crashloop.md)
- [ImagePullBackOff runbook](docs/runbook-imagepull.md)

## Learnings

- Kustomize base + overlay pattern for multi-environment delivery
- Liveness/readiness probes and resource limits
- Ingress routing and ConfigMap-driven configuration

Author: **Deonarayan** — Cloud DevOps Engineer
