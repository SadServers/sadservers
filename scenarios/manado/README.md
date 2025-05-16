# "Manado": How much do you press?

## Description:
You have been tasked with compressing the file _/home/admin/names_, which is 35147 bytes, to a size smaller than 9400 bytes. You can use any compressing tool at your disposal (there are many available in the server), also you can modify the file without deleting anything in it. Put the solution (compressed file) in the _/home/user/admin/solution_ directory with the default extension used by the compression tool (example: ~/solution/names.gzip).

Test:
The size of the compressed file is smaller than 9400 bytes.  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash

# Directory path
solution_folder="/home/admin/solution"

# List of compression tools to try
compression_tools=("xz" "gzip" "lbzip2" "lz4" "lzip" "lzop" "zstd")

# Loop through each compression tool
for tool in "${compression_tools[@]}"; do
    # Find compressed files for the current tool
    compressed_files=$(find "$solution_folder" -maxdepth 1 -type f -name "*.${tool}" 2>/dev/null)

    # Loop through each compressed file found
    for compressed_file in $compressed_files; do
        # Check if the compressed file size is less than 9400 bytes
        if [ $(stat -c %s "$compressed_file") -lt 9400 ]; then
            # Attempt to decompress the file
            if "$tool" -d "$compressed_file" -c > "$solution_folder/temp_uncompressed.txt"; then
                # Check if the size of the uncompressed file is at least 35000 bytes
                if [ $(stat -c %s "$solution_folder/temp_uncompressed.txt") -ge 35000 ]; then
                    # Count the number of words in the uncompressed file
                    word_count=$(wc -w < "$solution_folder/temp_uncompressed.txt")

                    # Check if the word count is 4950
                    if [ "$word_count" -eq 4950 ]; then
                        echo -n "OK"
                        exit 0  # Exit script with success status
                    fi
                fi
            fi
        fi
    done
done

# If none of the compressed files meet all conditions
echo -n "NO"
```
