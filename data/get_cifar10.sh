#!/usr/bin/env sh

# Exit immediately if a command exits with a non-zero status (optional safety)
set -e  # Exit on any error

# Ensure script runs in the current directory
SCRIPT_DIR="$(pwd)"
cd "$SCRIPT_DIR"

# Check if cifar10 already exists and is non-empty
if [ -d "cifar10" ] && [ -n "$(ls -A "cifar10")" ]; then
    echo "cifar10 directory already exists and is not empty. Skipping download."
    exit 0
fi

# Check if cifar10.tgz exists before downloading
if [ -f "data/cifar10.tgz" ]; then
    echo "cifar10.tgz already exists. Skipping download."
else
    echo "Downloading CIFAR-10 dataset..."
    mkdir -p data
    wget -O data/cifar10.tgz https://s3.amazonaws.com/fast-ai-imageclas/cifar10.tgz

    # Extract the dataset
    echo "Extracting CIFAR-10 dataset..."
    tar -xzf data/cifar10.tgz -C data
fi


echo "Done."
