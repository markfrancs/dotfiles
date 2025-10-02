#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# --- Configuration ---
FONT_URL="https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
FONT_ARCHIVE_NAME="jetbrains_mono.zip"

DOWNLOAD_DIR="$HOME/Downloads/"

# Local user installation ($HOME/.local/share/fonts/) or all users installation (/usr/share/fonts/)
INSTALL_DIR="$HOME/.local/share/fonts/"

FONT_DOWNLOAD_PATH="${DOWNLOAD_DIR}${FONT_ARCHIVE_NAME}"
FONT_FILES_PATH="${FONT_DOWNLOAD_PATH}/fonts/ttf/"

# --- Functions ---

# Function to display error messages and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# --- Main Script ---

echo "Starting font download and installation..."

echo "Font download path: $FONT_DOWNLOAD_PATH"

# Create the installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR" || error_exit "Failed to create font installation directory."

# Download the font archive
echo "Downloading font from $FONT_URL..."
curl -L -o "$FONT_ARCHIVE_NAME" "$FONT_URL" --output-dir "$DOWNLOAD_DIR" || error_exit "Failed to download font archive to $DOWNLOAD_DIR directory."

# Extract the font archive
echo "Extracting font archive..."
if [[ "$FONT_DOWNLOAD_PATH" == *.zip ]]; then
    unzip -q "$FONT_DOWNLOAD_PATH" -d "$INSTALL_DIR" || error_exit "Failed to extract ZIP archive."
elif [[ "$FONT_DOWNLOAD_PATH" == *.tar.gz ]]; then
    tar -xzf "$FONT_DOWNLOAD_PATH" -C "$INSTALL_DIR" || error_exit "Failed to extract TAR.GZ archive."
else
    error_exit "Unsupported archive format. Please use .zip or .tar.gz."
fi

# Update the font cache (the directories to be scanned are defined in the Fontconfig configuration files, with the primary file being /etc/fonts/fonts.conf)
echo "Updating font cache..."
fc-cache -fv || error_exit "Failed to update font cache."

# Clean up the downloaded archive
# echo "Cleaning up downloaded archive..."
# rm "$FONT_DESTINATION" || echo "Warning: Failed to remove temporary archive."

echo "Font installation complete. You may need to restart applications to see the new fonts."