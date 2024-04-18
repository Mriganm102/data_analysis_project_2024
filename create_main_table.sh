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

# Get the first line of the CSV file (assuming it contains the header)
header=$(head -n 1 "$csv_file")
echo "$header"
column_definitions=$(echo "$header" | sed "s/,/ TEXT,/g")

column_definitions+=" TEXT"
# Output the header
echo "$column_definitions"

table_name=$(basename "$csv_file" .csv)

# Create MySQL table
mysql --local-infile=1 -h "$host" -u "$username" -p"$password" "$database" <<EOF
CREATE TABLE IF NOT EXISTS $table_name (
$column_definitions
);
EOF

# Check if the table creation was successful
if [ $? -eq 0 ]; then
    echo "Table created successfully."
else
    echo "Error: Failed to create table."
fi
