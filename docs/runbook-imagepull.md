# ImagePullBackOff Runbook

## Symptoms

- Pod status: `ImagePullBackOff` or `ErrImagePull`
- Events show `Failed to pull image`

## Diagnosis

```bash
kubectl describe pod <pod-name> -n <namespace> | grep -A5 Events
kubectl get deployment <prefix>web-app -n <namespace> -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Common causes

| Cause | Fix |
|-------|-----|
| Wrong image tag | Update `images` block in kustomization overlay |
| Private registry | Add `imagePullSecrets` to deployment |
| Registry outage | Retry or use cached mirror tag |
| Typo in image name | Fix base deployment image reference |

## Remediation

1. Verify image exists locally (minikube/kind):
   ```bash
   docker pull nginx:1.25-alpine
   ```
2. Update overlay image tag:
   ```yaml
   images:
     - name: nginx
       newTag: 1.25-alpine
   ```
3. Re-apply and smoke test:
   ```bash
   kubectl apply -k k8s/overlays/staging
   ./scripts/smoke-test.sh staging
   ```

## Prevention

- Pin image tags (never `latest` in staging/prod)
- Use image digest in production overlays
- Pre-pull images in CI before deploy
