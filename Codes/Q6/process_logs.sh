#!/bin/bash

# Step 1: Read all log files in the "logs" directory
logs_dir="logs"
filtered_logs="filtered_logs.txt"

# Step 2, 3, and 4: Extract, filter, and sort log entries
for logfile in "$logs_dir"/log_*.txt; do
    filename=$(basename "$logfile")
    grep -E '^[0-9]{8} [0-9]{6}: ' "$logfile" | \
    awk -v filename="$filename" -v cutoff_date="2023-07-01" '
        BEGIN {
            print "Processing " filename "..."
            max_diff = 0
            total_diff = 0
            num_entries = 0
            max_avg_msg_len = 0
        }

        {
            # Step 2: Extract timestamp and message from each log entry
            timestamp = substr($0, 1, 15)
            message = substr($0, 17)

            # Step 3: Filter out log entries older than the given date
            if (timestamp >= cutoff_date) {
                # Step 4: Sort remaining log entries in descending order based on their timestamps
                log_entries[timestamp] = message

                # Calculate time difference for average calculation
                if (prev_timestamp != "") {
                    diff = mktime(substr(timestamp, 1, 4) " " substr(timestamp, 5, 2) " " substr(timestamp, 7, 2) " " substr(timestamp, 9, 2) " " substr(timestamp, 11, 2) " " substr(timestamp, 13, 2)) -
                           mktime(substr(prev_timestamp, 1, 4) " " substr(prev_timestamp, 5, 2) " " substr(prev_timestamp, 7, 2) " " substr(prev_timestamp, 9, 2) " " substr(prev_timestamp, 11, 2) " " substr(prev_timestamp, 13, 2))
                    total_diff += diff
                    num_entries++
                    if (diff > max_diff) {
                        max_diff = diff
                    }
                }
                prev_timestamp = timestamp

                # Track message length for average calculation
                total_msg_len += length(message)
                num_msgs++
                avg_msg_len = total_msg_len / num_msgs
                if (avg_msg_len > max_avg_msg_len) {
                    max_avg_msg_len = avg_msg_len
                }
            }
        }

        END {
            # Step 5: Write the sorted log entries to a new file named "filtered_logs.txt"
            print "Filename: " filename > "'"$filtered_logs"'"
            print "Maximum Average Time Difference: " max_diff " seconds." > "'"$filtered_logs"'"
            print "Longest Average Message Length: " max_avg_msg_len " characters." > "'"$filtered_logs"'"

            for (timestamp in log_entries) {
                print "Timestamp: " timestamp > "'"$filtered_logs"'"
                print "Message: " log_entries[timestamp] > "'"$filtered_logs"'"
            }

            # Step 6: Calculate average time difference between consecutive log entries
            if (num_entries > 0) {
                avg_time_diff = total_diff / num_entries
                print "Average Time Difference: " avg_time_diff " seconds." > "'"$filtered_logs"'"
            }
        }
    '
done

# Step 7 and 8: Find the log file with the maximum average time difference
max_avg_time_diff_file=$(grep -r "Maximum Average Time Difference" "$filtered_logs" | sort -k5 -n -r | head -1 | awk -F ': ' '{print $2}')
echo "File with Maximum Average Time Difference: $max_avg_time_diff_file"

# Step 9 and 10: Find the log file with the longest average message length
max_avg_msg_len_file=$(grep -r "Longest Average Message Length" "$filtered_logs" | sort -k5 -n -r | head -1 | awk -F ': ' '{print $2}')
echo "File with Longest Average Message Length: $max_avg_msg_len_file"
