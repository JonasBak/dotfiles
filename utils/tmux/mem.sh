#!/bin/bash
echo "Mem:$(free -t | \
  grep "Mem" | \
  awk '{print int($3/$2 * 100)}' | \
  awk '{printf "#[fg=colour112]"} \
  $1>40 {printf "#[fg=colour215]"} \
  $1>70 {printf "#[fg=colour160]"} \
  {printf "%3d%#[fg=colour15]", $1}')"
