#!/bin/bash
echo Docker: $(docker ps | wc -l | awk '{print $1-1}')
