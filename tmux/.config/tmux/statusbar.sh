#!/bin/bash

STATUS=""

if [[ -f ~/.needs_backup ]]; then
  STATUS="backup needed"
fi

K8S_CONTEXT="$(kubectl config current-context 2>/dev/null)"

if [[ -n "$K8S_CONTEXT" ]]; then
  K8S_CONTEXT="#[fg=colour1]#[bold]k8s ctx: $K8S_CONTEXT"
fi

echo "$STATUS $K8S_CONTEXT"
