#!/bin/bash
if command -v docker>/dev/null; then
  echo 🐋: $(docker ps -q | wc -l)
fi
