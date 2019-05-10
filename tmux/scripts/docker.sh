#!/bin/bash
if command -v docker>/dev/null; then
  echo -e "\uf308 $(docker ps -q | wc -l)"
fi
