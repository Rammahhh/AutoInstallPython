#!/bin/bash

# Script to download and install the latest Python version

# Exit on error
set -e

# Install dependencies required to build Python
sudo apt-get update
sudo apt-get install -y wget build-essential libssl-dev libffi-dev \
libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev \
xz-utils tk-dev liblzma-dev llvm libgdbm-dev zlib1g-dev libgdbm-compat-dev

# Download the latest Python source
LATEST_PYTHON_URL="https://www.python.org/ftp/python/"
LATEST_VERSION=$(wget -qO- $LATEST_PYTHON_URL | grep tar.xz | sed -n 's/.*href="\(.*\)\/".*/\1/p' | sort -V | tail -1)
wget $LATEST_PYTHON_URL$LATEST_VERSION/Python-$LATEST_VERSION.tar.xz

# Extract the downloaded tarball
tar -xf Python-$LATEST_VERSION.tar.xz

# Change to the extracted directory
cd Python-$LATEST_VERSION

# Configure the build
./configure --enable-optimizations

# Build and install Python (using altinstall to prevent replacing default python binary)
make -j $(nproc)
sudo make altinstall

# Verify installation
python3.10 --version

# Clean up downloaded files
cd ..
rm -rf Python-$LATEST_VERSION.tar.xz Python-$LATEST_VERSION

echo "Latest Python version installed successfully."
