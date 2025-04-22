#!/bin/bash

# Địa chỉ Prometheus
PROM_URL="http://192.168.60.101:9090"

# Danh sách truy vấn metric cần lấy
declare -A metrics
metrics["CPU Usage (%)"]="100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[1m])) * 100)"
metrics["RAM Usage (%)"]="100 * (1 - ((node_memory_MemAvailable_bytes) / (node_memory_MemTotal_bytes)))"
metrics["Disk Usage (%)"]="100 * ((node_filesystem_size_bytes{mountpoint=\"/\"} - node_filesystem_free_bytes{mountpoint=\"/\"}) / node_filesystem_size_bytes{mountpoint=\"/\"})"
metrics["Open File Descriptors"]="node_filefd_allocated"
metrics["IO Read (bytes/s)"]="rate(node_disk_read_bytes_total[1m])"
metrics["IO Write (bytes/s)"]="rate(node_disk_written_bytes_total[1m])"
metrics["Network RX (bytes/s)"]="rate(node_network_receive_bytes_total[1m])"
metrics["Network TX (bytes/s)"]="rate(node_network_transmit_bytes_total[1m])"
metrics["System Load 1m"]="node_load1"

echo "🔍 Fetching metrics from Prometheus: $PROM_URL"
echo "---------------------------------------------"

for label in "${!metrics[@]}"; do
    query="${metrics[$label]}"
    echo -e "\n📌 $label:"
    curl -sG "$PROM_URL/api/v1/query" --data-urlencode "query=$query" | \
        jq -r '
        .data.result[] |
        "  Instance: \(.metric.instance // "unknown") | Value: \(.value[1])"
        '
done
