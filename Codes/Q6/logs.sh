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

    while IFS= read -r line; 
    do
        if [[ $line == Timestamp:* ]]; 
        then
            # Extract timestamp from the log entry
            timestamp=$(echo "$line" | awk -F ': ' '{print $2}')
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

    # Create output file for each log file
    output_filename="${logfile%.*}_output.txt"
    echo "Filename: $logfile" > "$output_filename"
    echo "Maximum Average Time Difference: ${average_time_diff} seconds." >> "$output_filename"
    echo "Longest Average Message Length: ${avg_msg_len} characters." >> "$output_filename"

done
