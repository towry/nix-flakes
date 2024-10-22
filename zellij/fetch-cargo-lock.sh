#!/usr/bin/env bash

# Read rev from flake.nix
rev=$(grep 'rev =' flake.nix | awk -F'"' '{print $2}')

# Construct the URL for the Cargo.lock file
url="https://raw.githubusercontent.com/pze/zellij/${rev}/Cargo.lock"

# Download the Cargo.lock file
echo "Downloading Cargo.lock from: ${url}"
curl -sSL "${url}" -o Cargo.lock

if [ $? -eq 0 ]; then
    echo "Successfully downloaded Cargo.lock"
else
    echo "Failed to download Cargo.lock"
    exit 1
fi
