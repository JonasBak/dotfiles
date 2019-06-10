#!/bin/bash
if [[ ! -z $PASSWORD_STORE_DIR ]] && type pass > /dev/null 2>&1; then
  n=$(pass git cherry | wc -l)
  if [[ n -gt 0 ]]; then
    echo "#[fg=colour160]pass!#[fg=colour15] | "
  fi
fi
