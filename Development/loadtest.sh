#!/bin/bash

ALLOC_COUNT=20       # Number of GameServers to allocate
INTERVAL=10           # Interval in seconds between allocations

for ((i = 1; i <= ALLOC_COUNT; i++))
do
  echo "Allocating GameServer $i..."

  kubectl create -f "/c/Users/juneg/GolandProjects/icc/Development/Agones/server_allocation.yaml"

  sleep $INTERVAL
done