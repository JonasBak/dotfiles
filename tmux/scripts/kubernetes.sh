#!/bin/bash
if command -v kubectl>/dev/null; then
  config=$(kubectl config current-context)
  if [ -z $config ]; then
    echo ⎈ [none]
  else
    echo ⎈ $config
  fi
fi

