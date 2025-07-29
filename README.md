# Server Stats - Bash Script

This Bash script provides a quick summary of essential server performance statistics. It is designed to work on most Linux systems and gives information about CPU usage, memory, disk space, system load, user sessions, and top resource-consuming processes.

## Features

- Total CPU usage:
  ```bash
  top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'
  ```
  * top -bn1: Runs top in batch mode (non-interactive), once. <br>
  * grep "Cpu(s)": Filters the CPU stats line. <br>
  * awk: Subtracts the idle CPU percentage (field 8) from 100 to calculate usage. <br>
  
- Total memory usage (used, total, and percentage):
  ```bash
  free -h | awk '/^Mem/ { printf "Used: %s / %s (%.2f%%)\n", $3, $2, $3*100/$2 }'
  ```
  * free -h: Shows human-readable memory usage.
  * awk: Extracts the used and total values and calculates the usage percentage.
  
- Disk usage of root (`/`) partition:
  ```bash
  df -h / | awk 'NR==2 {printf "Used: %s / %s (Available: %s)\n", $3, $2, $4}'
  ```
  * df -h /: Shows disk space for the root (/) partition.
  * awk 'NR==2': Selects the second line of output.
  * Prints used, total, and available space.

- Top 5 processes by CPU usage:
  ```bash
  ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6
  ```
  * ps -eo: Lists all processes with PID, PPID, command, and CPU usage.
  * --sort=-%cpu: Sorts descending by CPU usage.
  * head -n 6: Returns top 5 (plus header).

- Top 5 processes by memory usage:
  ```bash
  ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6
  ```
  
- OS version:
  ```bash
  cat /etc/os-release | grep -E "^PRETTY_NAME" | cut -d= -f2 | tr -d '"'
  ```
  * Reads /etc/os-release, the standard OS metadata file.
  * Filters the line with PRETTY_NAME, which gives the full name of the OS.
  * Removes extra characters.
    
- System uptime:
  ```bash
  uptime -p
  ```
  
- Load average (1, 5, 15 min):
  ```bash
  uptime | awk -F'load average: ' '{ print $2 }'
  ```
  * Uses uptime to extract load average for the last 1, 5, and 15 minutes.
  * awk splits and prints only the load average values.
    
- Logged-in users:
  ```bash
  who | awk '{print $1}' | sort | uniq -c
  ```
  * who: Lists logged-in users and sessions.
  * awk '{print $1}': Extracts usernames.
  * sort | uniq -c: Counts how many sessions per user.


# Log Archive Tool

This is a simple command-line Bash tool to archive and compress logs from a specified directory. It is especially useful for managing large or growing log directories (e.g., `/var/log`) by periodically compressing them and storing the archives for future reference.

## Features

- Accepts a source log directory via `--source`
- Optionally accepts an archive destination via `--dest`
- Compresses logs (excluding `.gz` files) into `.tar.gz` format
- Archives are saved with timestamps for tracking
- Logs each archive operation in a persistent `archive_log.txt` file
- Includes error handling for missing directories or compression failures

## Code Explanation
- Usage Function:
  ```bash
  usage() {
    echo "Usage: $0 --source <log-directory> [--dest <archive-directory>]"
    exit 1
  }
  ```
  * Defines a function to print usage instructions if the script is used incorrectly or with missing arguments.
    
- Argument Parsing with getopts-style logic
  ```bash
  while [[ $# -gt 0 ]]; do
    case "$1" in
        --source)
            LOG_DIR="$2"
            shift 2
            ;;
        --dest)
            ARCHIVE_DIR="$2"
            shift 2
            ;;
        -*|--*)
            echo "Unknown option: $1"
            usage
            ;;
        *)
            echo "Unexpected argument: $1"
            usage
            ;;
    esac
  done
  ```
  * Loops over command-line arguments.
  * Sets LOG_DIR and ARCHIVE_DIR based on --source and --dest.
  * Shows an error if unexpected arguments are passed.

- Validation Checks:
  ```bash
  if [ -z "$LOG_DIR" ]; then
    echo "Error: Log directory (--source) is required."
    usage
  fi

  if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' not found."
    exit 1
  fi
  ```
  * Ensures the source directory is provided.
  * Confirms it exists and is a valid directory.

- Create Archive Directory:
  ```bash
  mkdir -p "$ARCHIVE_DIR"
  ```
  * Creates the archive directory if it does not already exist (-p avoids errors if it already exists).

- Generate Archive Name:
  ```bash
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
  ARCHIVE_PATH="${ARCHIVE_DIR}/${ARCHIVE_NAME}"
  ```
  * date generates a timestamp string.
  * The final archive file name is composed as logs_archive_<timestamp>.tar.gz.
 
- Create Archive (excluding .gz files):
  ```bash
  tar --exclude='*.gz' -czf "$ARCHIVE_PATH" -C "$LOG_DIR" . 2>/dev/null
  ```
  * tar: archiving tool.
  * --exclude='*.gz': skips already compressed .gz files.
  * -c: create archive.
  * -z: gzip compression.
  * -f: archive file name.
  * -C "$LOG_DIR": change into the source log directory.
  * .: archive everything inside.
  * 2>/dev/null: hides warnings/errors (optional, for cleaner output).

- Error Handling for tar:
  ```bash
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create archive."
    exit 1
  fi
  ```
  * Checks if the tar command failed ($? = last command’s exit status).

- Log Archive Details:
  ```bash
  echo "$TIMESTAMP: Archived logs from $LOG_DIR to $ARCHIVE_PATH" >> "$ARCHIVE_DIR/archive_log.txt"
  ```
  * Appends a line to archive_log.txt with the date, source, and destination of the archive.






