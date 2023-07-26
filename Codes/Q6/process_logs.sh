#!/bin/bash

logs_directory="logs"
output_file="filtered_logs.txt"
filter_date="2022-01-33 10:00:00"

# Check if the logs directory exists
if [ ! -d "$logs_directory" ]; 
then
    echo "Error: Directory '$logs_directory' does not exist."
    exit 1
fi

# Process each log file
for logfile in "$logs_directory"/log_*.txt; 
do
    # Extract the timestamp and message from each log entry
    timestamp=""
    message=""
    timestamps=()

    # Get the date part from the logfile name (e.g., "20220133" from "log_20220133.txt")
    log_date=$(basename "$logfile" | grep -oE '[0-9]{8}')

    # Extract year, month, and day from log_date
    log_year="${log_date:0:4}"
    log_month="${log_date:4:2}"
    log_day="${log_date:6:2}"

    # Check if the year, month, and day fields are within the valid ranges
    if ! ( ((log_year >= 1000 && log_year <= 9999)) && 
           ((log_month >= 1 && log_month <= 12)) && 
           ((log_day >= 1 && log_day <= 31)) ); then
        echo "Invalid date in log file: $logfile. Skipping the log file."
        continue
    fi

    while IFS= read -r line; 
    do
        if [[ $line == Timestamp:* ]]; 
        then
            # Extract timestamp from the log entry
            timestamp=$(echo "$line" | awk -F ': ' '{print $2}')

            # Check if the timestamp is in the correct format (YYYY-MM-DD HH:MM:SS)
            if ! date -d "$timestamp" &>/dev/null; then
                echo "Invalid timestamp in log file: $logfile. Skipping entry: $line"
                continue
            fi

            timestamps+=($(date -d "$timestamp" +%s))
        elif [[ $line == Message:* ]]; 
        then
            # Extract message from the log entry
            message=$(echo "$line" | awk -F ': ' '{print $2}')
        fi
    done < "$logfile"

    # Calculate average message length
    total_msg_len=0
    num_msgs=0

    while IFS= read -r line; 
    do
        if [[ $line == Message:* ]]; 
        then
            # Extract message from the log entry and calculate its length
            message=$(echo "$line" | awk -F ': ' '{print $2}')
            msg_len=${#message}
            total_msg_len=$((total_msg_len + msg_len))
            num_msgs=$((num_msgs + 1))
        fi
    done < "$logfile"

    if [ $num_msgs -gt 0 ]; 
    then
        avg_msg_len=$((total_msg_len / num_msgs))
    else
        avg_msg_len=0
    fi

    # Calculate average time difference
    num_entries=${#timestamps[@]}
    average_time_diff=0

    if [ $num_entries -gt 1 ]; 
    then
        total_diff=0

        for (( i=1; i<num_entries; i++ )); 
        do
            diff=$((timestamps[i] - timestamps[i - 1]))
            total_diff=$((total_diff + diff))
        done

        average_time_diff=$((total_diff / (num_entries - 1)))
    fi

    # Compare log file date timestamp with the filter date
    filter_year=$(date -d "$filter_date" "+%Y")
    filter_month=$(date -d "$filter_date" "+%m")
    filter_day=$(date -d "$filter_date" "+%d")

    if ((log_year < filter_year)) || 
        ((log_year == filter_year && log_month < filter_month)) || 
        ((log_year == filter_year && log_month == filter_month && log_day <= filter_day)); 
    then
        # Create output file for each log file
        output_filename="${logfile%.*}_output.txt"
        echo "Filename: $logfile" > "$output_filename"
        echo "Maximum Average Time Difference: ${average_time_diff} seconds." >> "$output_filename"
        echo "Longest Average Message Length: ${avg_msg_len} characters." >> "$output_filename"
    fi

done
