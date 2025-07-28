#!/bin/bash

# Total CPU Usage
echo -e "\nTotal CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'

# Total Memory Usage
echo -e "\nMemory Usage:"
free -h | awk '/^Mem/ {
    printf "Used: %s / %s (%.2f%%)\n", $3, $2, $3*100/$2
}'

# Total Disk Usage
echo -e "\nDisk Usage (/ partition):"
df -h / | awk 'NR==2 {printf "Used: %s / %s (Available: %s)\n", $3, $2, $4}'

# Top 5 processes by CPU
echo -e "\nTop 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by Memory
echo -e "\nTop 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6


# OS Version
echo -e "\nOS Version:"
cat /etc/os-release | grep -E "^PRETTY_NAME" | cut -d= -f2 | tr -d '"'

# Uptime
echo -e "\nUptime:"
uptime -p

# Load Average
echo -e "\nLoad Average (1, 5, 15 min):"
uptime | awk -F'load average: ' '{ print $2 }'

# Logged-in Users
echo -e "\nLogged-in Users:"
who | awk '{print $1}' | sort | uniq -c