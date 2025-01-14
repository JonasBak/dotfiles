#!/bin/bash

STATUS=""

if [[ -f ~/.needs_backup ]]; then
  STATUS="backup needed"
fi

echo "$STATUS"
