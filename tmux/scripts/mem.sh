#!/bin/bash
echo "Mem:$(free -t | \
  grep "Mem" | \
  awk '{print int($4/$2 * 100)}' | \
  awk '$1<=35 {printf "#[fg=colour112]"} \
  $1>30 {printf "#[fg=colour215]"} \
  $1>70 {printf "#[fg=colour160]"} \
  {printf "%3d%#[fg=colour15]", $1}')"
