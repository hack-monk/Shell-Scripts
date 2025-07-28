# Server Stats - Bash Script

This Bash script provides a quick summary of essential server performance statistics. It is designed to work on most Linux systems and gives information about CPU usage, memory, disk space, system load, user sessions, and top resource-consuming processes.

## Features

- Total CPU usage
  ```bash
  top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'
-- top -bn1: Runs top in batch mode (non-interactive), once.
-- grep "Cpu(s)": Filters the CPU stats line.
-- awk: Subtracts the idle CPU percentage (field 8) from 100 to calculate usage.
- Total memory usage (used, total, and percentage)
- Disk usage of root (`/`) partition
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- OS version
- System uptime
- Load average (1, 5, 15 min)
- Logged-in users


