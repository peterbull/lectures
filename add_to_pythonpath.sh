#!/bin/bash

# add_to_pythonpath.sh
# Usage: ./add_to_pythonpath.sh /path/to/directory [pth_file_name]

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 /path/to/directory [pth_file_name]"
    echo "Example: $0 /Users/peterbull/peter-projects/gpu-mode/lectures/triton/python custom_modules"
    exit 1
fi

# Get the directory path from the first argument
DIR_PATH="$1"

# Check if the directory exists
if [ ! -d "$DIR_PATH" ]; then
    echo "Error: Directory '$DIR_PATH' does not exist"
    exit 1
fi

# Get the name for the .pth file (use second argument or default to "custom_modules")
if [ -n "$2" ]; then
    PTH_NAME="$2"
else
    PTH_NAME="custom_modules"
fi

# Get the site-packages directory
SITE_PACKAGES=$(uv run python -c "import site; print(site.getsitepackages()[0])")
PTH_FILE="$SITE_PACKAGES/$PTH_NAME.pth"

# Check if the .pth file already exists
if [ -f "$PTH_FILE" ]; then
    # Check if this path is already in the file
    if grep -q "^$DIR_PATH$" "$PTH_FILE"; then
        echo "Path '$DIR_PATH' is already in $PTH_FILE"
    else
        # Append the new path to the existing file
        echo "$DIR_PATH" >> "$PTH_FILE"
        echo "Added '$DIR_PATH' to existing $PTH_FILE"
    fi
else
    # Create a new .pth file
    echo "$DIR_PATH" > "$PTH_FILE"
    echo "Created new $PTH_FILE with path '$DIR_PATH'"
fi

# Verify the path is now accessible
echo "Verifying path is accessible..."
uv run python -c "import sys; print('$DIR_PATH' in sys.path or 'Path not found in sys.path')"

echo "You may need to restart your Python interpreter for changes to take effect"
