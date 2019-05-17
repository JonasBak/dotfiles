#!/bin/bash
if command -v docker>/dev/null; then
  echo -e "#{?PATCHED_FONT,\uf308,🐋} $(docker ps -q | wc -l) |"
fi
