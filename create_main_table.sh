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


# Prompt for the MySQL table name
read -p "Enter the MySQL table name: " table_name

# Prompt for the column names and types in the MySQL table (comma-separated)
read -p "Enter the column names and types in the MySQL table (e.g., 'column1 INT, column2 VARCHAR(255), ...'): " column_definitions

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
