#!/bin/bash

# Figlet ASCII art with "NK"
echo "======================="
figlet "NK Spec Report"
echo "======================="

# Get the total number of CPU cores
cpu_core_count=$(grep -c ^processor /proc/cpuinfo)

echo "Total CPU Cores: $cpu_core_count"

# Get total RAM
total_ram=$(free -m | awk '/^Mem:/{print $2}')
total_used_ram=$(free -m | awk '/^Mem:/{print $3}')

echo "Total RAM: ${total_ram}MB"
echo "Total Used RAM: ${total_used_ram}MB"

# Get total storage of root partition
total_bytes=$(df --block-size=1 / | awk 'NR==2 {print $2}')
total_storage=$(echo "scale=2; $total_bytes / (1024 * 1024 * 1024)" | bc)

echo "Total Storage: ${total_storage}GB (root)"

# Get total used memory
total_used_memory=$(docker stats --no-stream --format "{{.MemUsage}}" $(docker ps -q) | awk '{sum += $1} END {print sum}')

echo "Total Used Memory: ${total_used_memory}"

# Get total used storage
total_bytes_used=$(df --block-size=1 / | awk 'NR==2 {print $3}')
total_used_storage=$(echo "scale=2; $total_bytes_used / (1024 * 1024 * 1024)" | bc)

echo "Total Used Storage: ${total_used_storage} (root)"

# Line with the hostname
echo "-----------------------"
echo "Hostname: $(hostname)"
echo "-----------------------"
echo ""
echo "Docker Containers"
echo "-----------------------"

# Get a list of running Docker container IDs
container_ids=$(docker ps -q)

# Iterate through each container ID
for container_id in $container_ids; do
    # Get container name
    container_name=$(docker inspect --format '{{ .Name }}' $container_id)
    
    # Get container CPU usage
    cpu_usage=$(docker stats --no-stream --format "table {{.CPUPerc}}" $container_id | tail -n 1)

    # Get container memory usage
    mem_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" $container_id | tail -n 1)

    # Print the results
    echo "Container: $container_name"
    echo "CPU Usage: $cpu_usage"
    echo "Memory Usage: $mem_usage"
    echo "-----------------------"
done
