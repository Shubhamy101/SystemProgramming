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

# Remove any existing output file
rm -f "$output_file"

# Variables to store maximum average time difference and the corresponding filename
max_average_diff=0
max_average_diff_filename=""

# Variables to store longest average message length and the corresponding filename
max_avg_msg_len=0
max_avg_msg_len_file=""

# Process each log file
for logfile in "$logs_directory"/log_*.txt; 
do
    # Extract the timestamp and message from each log entry
    timestamp=""
    message=""

    while IFS= read -r line; 
    do
        if [[ $line == Timestamp:* ]]; 
        then
            # Extract timestamp from the log entry
            timestamp=$(echo "$line" | awk -F ': ' '{print $2}')
        fi
        if [[ $line == Message:* ]]; 
        then
            # Extract message from the log entry
            message=$(echo "$line" | awk -F ': ' '{print $2}')
        fi
    done < "$logfile"

    # Check if the timestamp is older than the filter date
    if [[ "$timestamp" < "$filter_date" ]];
    then
        echo "Timestamp: $timestamp" >> "$output_file"
        echo "Message: $message" >> "$output_file"
    fi

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

        # Check if the current log file has the longest average message length
        if [ $avg_msg_len -gt $max_avg_msg_len ]; 
        then
            max_avg_msg_len=$avg_msg_len
            max_avg_msg_len_file=$(basename "$logfile")
        fi
    fi

    # Calculate average time difference
    timestamps=()

    while IFS= read -r line; 
    do
        if [[ $line == Timestamp:* ]]; 
        then
            # Extract timestamp from the log entry and convert it to Unix timestamp
            timestamp=$(echo "$line" | awk -F ': ' '{print $2}')
            timestamp=$(date -d "${timestamp}" "+%s")
            timestamps+=($timestamp)
        fi
    done < "$logfile"

    total_diff=0
    num_entries=${#timestamps[@]}

    for (( i=1; i<num_entries; i++ )); 
    do
        diff=$((timestamps[i] - timestamps[i - 1]))
        total_diff=$((total_diff + diff))
    done

    average_time_diff=$((total_diff / (num_entries - 1)))

    # Check if the current log file has the maximum average time difference
    if [ $average_time_diff -gt $max_average_diff ]; 
    then
        max_average_diff=$average_time_diff
        max_average_diff_filename=$(basename "$logfile")
    fi

done

# Print and save the output for the log file with the maximum average time difference
echo "Filename: $(basename "$max_average_diff_filename")"
echo "Maximum Average Time Difference: ${max_average_diff} seconds."

# Print and save the output for the log file with the longest average message length
echo "Filename: $(basename "$max_avg_msg_len_file")"
echo "Longest Average Message Length: ${max_avg_msg_len} characters."

# Save the output to a file
echo "Filename: $(basename "$max_average_diff_filename")" > "output.txt"
echo "Maximum Average Time Difference: ${max_average_diff} seconds." >> "output.txt"
echo "Filename: $(basename "$max_avg_msg_len_file")" >> "output.txt"
echo "Longest Average Message Length: ${max_avg_msg_len} characters." >> "output.txt"
