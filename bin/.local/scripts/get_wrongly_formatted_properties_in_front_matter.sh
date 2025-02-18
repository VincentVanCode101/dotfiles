#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <yaml_field>"
    exit 1
fi

FIELD_NAME="$1"

is_valid_format() {
    [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]
}

find . -type f -name "*.md" | while read -r file; do
    field_entries=$(grep -oP "^$FIELD_NAME:\s*\[\K[^\]]+" "$file" | tr -d '"')

    for entry in $(echo "$field_entries" | tr ',' '\n'); do
        entry=$(echo "$entry" | xargs)
        if ! is_valid_format "$entry"; then
            echo "Invalid entry in file: $file"
            break
        fi
    done
done
