#!/bin/bash
echo "CPU:$(top -bn2 -d0.2 | \
  grep "Cpu(s)" | \
  sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
  tail -1 | \
  awk '{print int(100 - $1)}' | \
  awk '{printf "#[fg=colour112]"} \
  $1>30 {printf "#[fg=colour215]"} \
  $1>70 {printf "#[fg=colour160]"} \
  {printf "%3d%#[fg=colour15]", $1}')"
