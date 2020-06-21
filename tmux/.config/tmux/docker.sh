#!/bin/bash
if command -v docker>/dev/null; then
  running=$(docker ps -q | wc -l)
  if [[ $running -ne 0 ]]; then
    echo -n "docker: $running"
  fi
fi
