#!/bin/bash

if [[ "$EUID" -eq 0 ]]; then echo "Do not run this script with sudo."; exit 1; fi

set -e

REPO_URL="https://github.com/Ackerman-00/end4-quiet-hypr-dots.git"
CLONE_DIR="$HOME/.cache/end4-quiet-hypr-dots"
BRANCH="main"

echo "Cloning Quiet End 4 Hyprland dotfiles for PikaOS (branch: $BRANCH)..."

# If the directory exists, prompt reuse or delete
if [[ -d "$CLONE_DIR" ]]; then
    echo "Directory $CLONE_DIR already exists."
    read -rp "Do you want to delete and re-clone it? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$CLONE_DIR"
        echo "Removed old directory."
    else
        echo "Reusing existing directory."
    fi
fi

# Clone if directory is missing
if [[ ! -d "$CLONE_DIR" ]]; then
    git clone --depth=1 --branch "$BRANCH" "$REPO_URL" "$CLONE_DIR" --recurse-submodules
    echo "Clone complete."
fi

cd "$CLONE_DIR" || { echo "Failed to enter $CLONE_DIR"; exit 1; }

chmod +x pikaos/pika.sh
bash pikaos/pika.sh
