#!/bin/bash
echo 🐋: $(docker ps -q | wc -l)
