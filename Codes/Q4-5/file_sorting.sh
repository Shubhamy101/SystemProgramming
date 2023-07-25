#!/bin/bash

#P rompt to user for directory name 
read -p "Enter the name of directory: " in_dir

# If directory does not exists, display error
if [ ! -d "$in_dir" ]; 
then
    echo "Error: Directory '$in_dir' does not exist."
    exit 1
fi

# Listing all the files in sorted order in the mentioned directory
file_list=$(ls "$in_dir" | sort)
echo "$file_list"

# Creating a new directory sorted
new_dir="$in_dir/sorted"
mkdir -p "$new_dir"

# Move each file from original to sorted directory
cnt=0
for file in $file_list; 
do
    mv "$in_dir/$file" "$new_dir"
    ((cnt++))
done

echo "Success: $cnt files moved to 'sorted' directory."
exit 0