#!/bin/bash

# Figlet ASCII art with "NK"
echo "======================="
figlet "NK"
echo "======================="

# Get the total number of CPU cores
cpu_core_count=$(grep -c ^processor /proc/cpuinfo)

echo "Total CPU Cores: $cpu_core_count"

# Get total RAM
total_ram=$(free -m | awk '/^Mem:/{print $2}')

echo "Total RAM: ${total_ram}MB"

# Get total storage of root
total_storage=$(df -h | grep -oP "^.*\/dev\/mapper\/ubuntu--vg-ubuntu--lv.*$" | awk '{print $2}')

echo "Total Storage: ${total_storage}"

# Get total used memory
total_used_memory=$(docker stats --no-stream --format "{{.MemUsage}}" $(docker ps -q) | awk '{sum += $1} END {print sum}')

echo "Total Used Memory: ${total_used_memory}"

# Get total used storage of system /dev/mapper/ubuntu--vg-ubuntu--lv
total_used_storage=$(df -h | grep -oP "^.*\/dev\/mapper\/ubuntu--vg-ubuntu--lv.*$" | awk '{print $3}')

echo "Total Used Storage: ${total_used_storage}"

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

    # # Get storage usage of container
    # storage_usage=$(docker inspect --format='{{json .GraphDriver.Data}}' $container_id | jq -r '.DeviceSize')

    # Print the results
    echo "Container: $container_name"
    echo "CPU Usage: $cpu_usage"
    echo "Memory Usage: $mem_usage"
    # echo "Storage Usage: $storage_usage"
    echo "-----------------------"
done
