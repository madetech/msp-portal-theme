#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the manifest file path
MANIFEST_FILE="manifest.json"

# Check if manifest.json exists
if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "Error: $MANIFEST_FILE not found!"
    exit 1
fi

# Extract the current version from manifest.json
CURRENT_VERSION=$(jq -r '.version' "$MANIFEST_FILE")
if [[ -z "$CURRENT_VERSION" ]]; then
    echo "Error: Version not found in $MANIFEST_FILE!"
    exit 1
fi

# Split the version into components (major, minor, patch)
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Increment the patch version
PATCH=$((PATCH + 1))

# Construct the new version
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update the version in manifest.json
jq ".version = \"$NEW_VERSION\"" "$MANIFEST_FILE" > temp.json && mv temp.json "$MANIFEST_FILE"

# Stage the updated manifest.json for commit
git add "$MANIFEST_FILE"

# Commit and push changes
git commit -m "Update manifest version to $NEW_VERSION"

# Output the new version
echo "Version updated to $NEW_VERSION and changes pushed to GitHub."
