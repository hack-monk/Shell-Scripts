# Server Stats - Bash Script

This Bash script provides a quick summary of essential server performance statistics. It is designed to work on most Linux systems and gives information about CPU usage, memory, disk space, system load, user sessions, and top resource-consuming processes.

## Features

- Total CPU usage
  ```bash
  top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'
  ```
  * top -bn1: Runs top in batch mode (non-interactive), once. <br>
  * grep "Cpu(s)": Filters the CPU stats line. <br>
  * awk: Subtracts the idle CPU percentage (field 8) from 100 to calculate usage. <br>
  
- Total memory usage (used, total, and percentage)
  ```bash
  free -h | awk '/^Mem/ { printf "Used: %s / %s (%.2f%%)\n", $3, $2, $3*100/$2 }'
  ```
  * free -h: Shows human-readable memory usage.
  * awk: Extracts the used and total values and calculates the usage percentage.
  
- Disk usage of root (`/`) partition
  ```bash
  df -h / | awk 'NR==2 {printf "Used: %s / %s (Available: %s)\n", $3, $2, $4}'
  ```
  * df -h /: Shows disk space for the root (/) partition.
  * awk 'NR==2': Selects the second line of output.
  * Prints used, total, and available space.

- Top 5 processes by CPU usage
  ```bash
  ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6
  ```
  * ps -eo: Lists all processes with PID, PPID, command, and CPU usage.
  * --sort=-%cpu: Sorts descending by CPU usage.
  * head -n 6: Returns top 5 (plus header).

- Top 5 processes by memory usage
  ```bash
  ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6
  ```
  
- OS version
  ```bash
  cat /etc/os-release | grep -E "^PRETTY_NAME" | cut -d= -f2 | tr -d '"'
  ```
  * Reads /etc/os-release, the standard OS metadata file.
  * Filters the line with PRETTY_NAME, which gives the full name of the OS.
  * Removes extra characters.
    
- System uptime
  ```bash
  uptime -p
  ```
  
- Load average (1, 5, 15 min)
  ```bash
  uptime | awk -F'load average: ' '{ print $2 }'
  ```
  * Uses uptime to extract load average for the last 1, 5, and 15 minutes.
  * awk splits and prints only the load average values.
    
- Logged-in users
  ```bash
  who | awk '{print $1}' | sort | uniq -c
  ```
  * who: Lists logged-in users and sessions.
  * awk '{print $1}': Extracts usernames.
  * sort | uniq -c: Counts how many sessions per user.

