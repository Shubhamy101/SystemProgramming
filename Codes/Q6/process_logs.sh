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

# Function to convert date string to timestamp
function get_timestamp {
    local date_str="$1"
    local year="${date_str:0:4}"
    local month="${date_str:5:2}"
    local day="${date_str:8:2}"
    local time="${date_str:11:8}"
    echo "$(date -d "$year-$month-$day $time" +%s)"
}

# Process each log file
for logfile in "$logs_directory"/log_*.txt; 
do
    # Extract the timestamp and message from each log entry
    timestamp=""
    message=""
    timestamps=()

    # Calculate timestamp for the log file
    while IFS= read -r line; 
    do
        if [[ $line == Timestamp:* ]]; 
        then
            # Extract timestamp from the log entry
            timestamp=$(echo "$line" | awk -F ': ' '{print $2}')
            break
        fi
    done < "$logfile"

    # Check if we successfully extracted the timestamp
    if [ -z "$timestamp" ]; then
        echo "Error: Unable to extract timestamp from log file: $logfile. Skipping the log file."
        continue
    fi

    # Calculate the timestamp from the date string
    timestamp=$(get_timestamp "$timestamp")

    while IFS= read -r line; 
    do
        if [[ $line == Timestamp:* ]]; 
        then
            # Extract timestamp from the log entry
            timestamp=$(echo "$line" | awk -F ': ' '{print $2}')
            timestamps+=($(get_timestamp "$timestamp"))
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

    log_year="${timestamp:0:4}"
    log_month="${timestamp:5:2}"
    log_day="${timestamp:8:2}"

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
