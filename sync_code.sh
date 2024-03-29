#!/bin/bash
# This script synchronizes the contents of a remote directory to the current directory using rsync, excluding the .build and venv directories.

# Define the remote server and directory
REMOTE_HOST="agp@ubuntu.sesar.int"
REMOTE_DIR="simulator-swift"
LOCAL_DIR="."
SSH_KEY="/Users/antongiacomopolimeno/.ssh/sesar"
EXCLUDE_DIR1=".build"
EXCLUDE_DIR2="venv"
EXCLUDE_DIR3="mysql"

# Execute the rsync command with exclusions
rsync -avz --exclude "$EXCLUDE_DIR1" --exclude "$EXCLUDE_DIR2" --exclude "$EXCLUDE_DIR3" -e "ssh -i $SSH_KEY" "$REMOTE_HOST:$REMOTE_DIR" "$LOCAL_DIR"

# Optional: add any post-synchronization commands or messages here
echo "Synchronization complete, excluding $EXCLUDE_DIR1 and $EXCLUDE_DIR2."
