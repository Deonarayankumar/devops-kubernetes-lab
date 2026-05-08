# CrashLoopBackOff Runbook

## Symptoms

- Pod status: `CrashLoopBackOff`
- Restarts incrementing rapidly
- Service unavailable behind Ingress

## Diagnosis

```bash
kubectl get pods -n <namespace> -l app=web-app
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
```

## Common causes

| Cause | Fix |
|-------|-----|
| Bad command/entrypoint | Fix container image or override command |
| Missing ConfigMap | `kubectl apply -k k8s/overlays/<env>` |
| Probe too aggressive | Increase `initialDelaySeconds` in deployment |
| OOM killed | Raise memory limits in deployment |

## Remediation

1. Scale deployment to zero to stop restart storm:
   ```bash
   kubectl scale deployment/<prefix>web-app -n <namespace> --replicas=0
   ```
2. Fix manifest or image tag in overlay.
3. Re-apply and verify:
   ```bash
   kubectl apply -k k8s/overlays/dev
   ./scripts/smoke-test.sh dev
   ```

## Escalation

If crash persists after image rollback, capture `kubectl get events` and open incident ticket.
