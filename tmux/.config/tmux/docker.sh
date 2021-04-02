#!/bin/bash
if command -v podman>/dev/null; then
  running=$(podman ps -q | wc -l)
  if [[ $running -ne 0 ]]; then
    echo -n "podman: $running"
  fi
fi
