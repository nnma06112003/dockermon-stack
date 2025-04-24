#!/bin/bash

nodes=("192.168.60.102" "192.168.60.103" "192.168.60.104" "192.168.60.107")

for node in "${nodes[@]}"; do
  echo "==== $node ===="
  ssh osboxes@$node "
    echo '-- CPU, RAM, Disk --'
    top -b -n1 | head -20

    echo -e '\n-- Disk Usage --'
    df -h

    echo -e '\n-- Running Processes --'
    ps aux --sort=-%mem | head -10

    echo -e '\n-- Open File Descriptors --'
    sudo lsof 2>/dev/null | wc -l

    echo -e '\n-- Socket Status --'
    ss -s

    echo -e '\n-- I/O Statistics --'
    sudo iostat -dx 1 1

    echo -e '\n-- CPU Temp / Fan Speed --'
    sudo sensors || echo 'sensors not available'
  "
  echo -e "\n\n"
done
