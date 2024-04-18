#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <host> <username> <password> <database>"
    exit 1
fi

# Assigning command line arguments to variables
host="$1"
username="$2"
password="$3"
database="$4"

# Check if mysql command is available
command -v mysql >/dev/null 2>&1 || { echo >&2 "mysql command not found. Please install MySQL client."; exit 1; }

# Prompt for the CSV file path
read -p "Enter the path to the CSV file: " csv_file

# Check if the CSV file exists
if [ ! -f "$csv_file" ]; then
    echo "Error: CSV file not found."
    exit 1
fi

table_name=$(basename "$csv_file" .csv)

# Importing data from CSV into MySQL table
mysql --local-infile=1 -h "$host" -u "$username" -p"$password" "$database" <<EOF
LOAD DATA LOCAL INFILE '$csv_file' INTO TABLE $table_name
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
EOF

# Check if the import was successful
if [ $? -eq 0 ]; then
    echo "Data imported successfully."
else
    echo "Error: Failed to import data into MySQL table."
fi
