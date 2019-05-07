#!/bin/bash
echo Mem: $(free -t | grep "Mem" | awk '{printf "%3s", int($4/$2 * 100)}')%
