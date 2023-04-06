#!/bin/bash

# Get source and target directories from command-line arguments
source_dir=$1
destination_dir=$2

# Check if destination is a remote server (contains "@")
if [[ $destination_dir == *"@"* ]]; then
  # Create backup directory with timestamp on remote server
  ssh "$destination_dir" "mkdir -p $destination_dir/$(date +%Y-%m-%d_%H-%M-%S)"
  
  # Copy files with rsync, preserving permissions, ownerships, and symlinks
  rsync -avz --delete --inplace --chmod=ugo=rwX \
    --rsync-path="mkdir -p \"$destination_dir/$(date +%Y-%m-%d_%H-%M-%S)\" && rsync" \
    "$source_dir" "$destination_dir:$destination_dir/$(date +%Y-%m-%d_%H-%M-%S)/"
else
  # Create backup directory with timestamp
  mkdir -p "$destination_dir/$(date +%Y-%m-%d_%H-%M-%S)"
  
  # Copy files with rsync, preserving permissions, ownerships, and symlinks
  rsync -avz --delete --inplace --chmod=ugo=rwX \
    --link-dest="$destination_dir/$(ls -1t $destination_dir | head -n1)" \
    "$source_dir" "$destination_dir/$(date +%Y-%m-%d_%H-%M-%S)/"
fi
