#!/usr/bin/env bash
set -euo pipefail

# get-next-version.sh
# Read version from pyproject.toml and output GitHub Actions variables
# Usage: get-next-version.sh

# Get the latest tag for release notes comparison
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "latest_tag=$LATEST_TAG" >> $GITHUB_OUTPUT

# Read version from pyproject.toml
if [[ -f "pyproject.toml" ]]; then
    VERSION=$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')
    NEW_VERSION="v$VERSION"
else
    # Fallback to git tag increment if pyproject.toml not found
    # Extract version number and increment
    VERSION=$(echo $LATEST_TAG | sed 's/v//')
    IFS='.' read -ra VERSION_PARTS <<< "$VERSION"
    MAJOR=${VERSION_PARTS[0]:-0}
    MINOR=${VERSION_PARTS[1]:-0}
    PATCH=${VERSION_PARTS[2]:-0}
    
    # Increment patch version
    PATCH=$((PATCH + 1))
    NEW_VERSION="v$MAJOR.$MINOR.$PATCH"
fi

echo "new_version=$NEW_VERSION" >> $GITHUB_OUTPUT
echo "New version will be: $NEW_VERSION"
