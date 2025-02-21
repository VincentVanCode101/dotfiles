#!/bin/bash

cat ~/ram_usage.log | awk '{sum += $7} END {print sum / NR}'
