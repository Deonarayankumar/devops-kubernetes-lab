#!/usr/bin/env bash
set -euo pipefail

ENV="${1:-dev}"

case "${ENV}" in
  dev)
    NAMESPACE="devops-lab-dev"
    PREFIX="dev-"
  ;;
  staging)
    NAMESPACE="devops-lab-staging"
    PREFIX="staging-"
  ;;
  *)
    echo "Unknown environment: ${ENV} (use dev or staging)" >&2
    exit 1
  ;;
esac

DEPLOYMENT="${PREFIX}web-app"
SERVICE="${PREFIX}web-app"

echo "==> Waiting for deployment/${DEPLOYMENT} in ${NAMESPACE}"
kubectl rollout status "deployment/${DEPLOYMENT}" -n "${NAMESPACE}" --timeout=120s

echo "==> Checking pod readiness"
kubectl wait --for=condition=ready pod \
  -l app=web-app -n "${NAMESPACE}" --timeout=60s

echo "==> Port-forward smoke check"
kubectl port-forward -n "${NAMESPACE}" "svc/${SERVICE}" 18080:80 &
PF_PID=$!
trap 'kill ${PF_PID} 2>/dev/null || true' EXIT
sleep 2

HTTP_CODE=$(curl -sS -o /dev/null -w "%{http_code}" http://localhost:18080/ || echo "000")
if [[ "${HTTP_CODE}" == "200" ]]; then
  echo "Smoke test passed for ${ENV} (HTTP ${HTTP_CODE})"
else
  echo "Smoke test failed for ${ENV} (HTTP ${HTTP_CODE})" >&2
  exit 1
fi
