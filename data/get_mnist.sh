#!/usr/bin/env bash
# Script to download and prepare MNIST dataset in image (PNG) format

# Exit on errors or unset variables, and propagate errors in pipelines
set -euo pipefail

# Ensure the script is running from its own directory (for relative paths to work)
DIR="$(pwd)"
cd "$DIR"

# Define the target directory and data source URL
DATA_DIR="data"
DATASET_DIR="$DATA_DIR/mnist_png"
ARCHIVE_NAME="$DATASET_DIR/mnist_png.tar.gz"
DOWNLOAD_URL="https://raw.githubusercontent.com/myleott/mnist_png/master/mnist_png.tar.gz"

# Check if the dataset directory already exists and is non-empty
if [ -d "$DATASET_DIR" ] && [ "$(ls -A "$DATASET_DIR")" ]; then
    echo "MNIST dataset already exists in '$DATASET_DIR' and is not empty. Skipping download."
    exit 0
else
    echo "MNIST dataset not found locally. Proceeding to download..."

    # Create the dataset directory if it does not exist
    mkdir -p "$DATASET_DIR"

    # Use wget or curl to download the dataset archive
    if command -v wget > /dev/null; then
        echo "Downloading MNIST dataset using wget..."
        wget -O "$ARCHIVE_NAME" "$DOWNLOAD_URL" \
            || { echo "Error: Download failed. Please check your internet connection or URL." >&2; exit 1; }
    elif command -v curl > /dev/null; then
        echo "Downloading MNIST dataset using curl..."
        curl -L -o "$ARCHIVE_NAME" "$DOWNLOAD_URL" \
            || { echo "Error: Download failed. Please check your internet connection or URL." >&2; exit 1; }
    else
        echo "Error: Neither wget nor curl is installed. Cannot download dataset." >&2
        exit 1
    fi

    echo "Download complete. Extracting the dataset..."

    # Extract the tar.gz archive
    tar -xf "$ARCHIVE_NAME" -C "$DATA_DIR" \
        || { echo "Error: Failed to extract $ARCHIVE_NAME. Archive might be corrupted." >&2; exit 1; }

    echo "Done. MNIST dataset is available in $DATASET_DIR."

    # Define source and destination directories
    TRAINING_DIR="$DATASET_DIR/training"
    ZERO_TO_EIGHT_DIR="$TRAINING_DIR/zero_to_eight"

    # Create 'all' directory inside 'data' if it doesn't exist
    mkdir -p "$ZERO_TO_EIGHT_DIR"

    # Copy directories 0 to 8 from 'data' into 'data/all'
    for i in {0..8}; do
        if [ -d "$TRAINING_DIR/$i" ]; then
            for file in "$TRAINING_DIR/$i"/*.png; do
                cp "$file" "$ZERO_TO_EIGHT_DIR/${i}_$(basename "$file")";
            done
            echo "Copied $TRAINING_DIR/$i to $ZERO_TO_EIGHT_DIR/"
        else
            echo "Directory $TRAINING_DIR/$i not found, skipping."
        fi
    done
fi
