#!/bin/bash

logs_dir="logs"
output_file="filtered_logs.txt"

# Task 1, 2, 3, and 4: Read log files, extract timestamp and message, filter by date, and sort by timestamp
find "$logs_dir" -type f -name "log_*.txt" -exec cat {} + | grep -E 'Timestamp: [0-9]{4}-[0-9]{2}-[0-9]{1,2} [0-9]{2}:[0-9]{2}:[0-9]{2}|Message:' | awk -v date_cutoff="2023-07-25 00:00:00" '
BEGIN {
    timestamp = "";
    message = "";
}
{
    if ($1 == "Timestamp:") {
        timestamp = $2 " " $3;
    } else if ($1 == "Message:") {
        message = substr($0, index($0, $1) + length($1) + 1);
    }

    if (timestamp != "" && message != "") {
        if (timestamp >= date_cutoff) {
            print "Timestamp: " timestamp;
            print "Message: " message;
            print "";
        }
        timestamp = "";
        message = "";
    }
}' | sort -r -k2 > "$output_file"

# Task 5: Write the sorted log entries to a new file named "filtered_logs.txt"

# Task 6: Calculate the average time difference between consecutive log entries for each log file.
awk '
function abs(x) {return x < 0 ? -x : x}

/^Timestamp:/ {
    if (prev_timestamp != "") {
        diff = systime() - mktime(prev_timestamp);
        total_diff += abs(diff);
        count++;
    }
    prev_timestamp = gensub(/[-:]/, " ", "g", $2 " " $3);
}
END {
    if (count > 0) {
        avg_diff = total_diff / count;
        print "Average Time Difference:", avg_diff, "seconds.";
    } else {
        print "No log entries found.";
    }
}' "$output_file"

# Task 7: Find the log file with the maximum average time difference.
max_avg_diff=0
max_avg_diff_file=""
for log_file in "$logs_dir"/log_*.txt; do
    avg_diff=$(awk -v prev_timestamp="" '
    function abs(x) {return x < 0 ? -x : x}

    /^Timestamp:/ {
        if (prev_timestamp != "") {
            diff = systime() - mktime(prev_timestamp);
            total_diff += abs(diff);
            count++;
        }
        prev_timestamp = gensub(/[-:]/, " ", "g", $2 " " $3);
    }
    END {
        if (count > 0) {
            avg_diff = total_diff / count;
            print avg_diff;
        } else {
            print 0;
        }
    }' "$log_file")

    if (( $(echo "$avg_diff > $max_avg_diff" | bc -l) )); then
        max_avg_diff="$avg_diff"
        max_avg_diff_file="$log_file"
    fi
done

# Task 8: Print and save the output filename and corresponding maximum average time difference.
echo "Filename: $(basename "$max_avg_diff_file")"
echo "Maximum Average Time Difference: $max_avg_diff seconds."
echo ""

# Task 9: Find the log file with the longest average message length.
longest_avg_length=0
longest_avg_length_file=""
for log_file in "$logs_dir"/log_*.txt; do
    avg_length=$(awk '
    /^Message:/ {
        total_length += length($0) - length("Message: ");
        count++;
    }
    END {
        if (count > 0) {
            avg_length = total_length / count;
            print avg_length;
        } else {
            print 0;
        }
    }' "$log_file")

    if (( $(echo "$avg_length > $longest_avg_length" | bc -l) )); then
        longest_avg_length="$avg_length"
        longest_avg_length_file="$log_file"
    fi
done

# Task 10: Print and save the output filename and corresponding longest average message length.
echo "Filename: $(basename "$longest_avg_length_file")"
echo "Longest Average Message Length: $longest_avg_length characters."
