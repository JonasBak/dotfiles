#!/bin/bash
if command -v kubectl>/dev/null; then
  config=$(kubectl config current-context)
  if [ -z $config ]; then
    echo -e "#{?PATCHED_FONT,\ufd31,⎈} [none] |"
  else
    echo -e "#{?PATCHED_FONT,\ufd31,⎈} $config |"
  fi
fi

