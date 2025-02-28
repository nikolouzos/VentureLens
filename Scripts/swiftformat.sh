#!/bin/bash

# Add Homebrew binary paths to PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Navigate to the project root directory
cd "$(dirname "$0")/../"

# Check if swiftformat is installed
if ! command -v swiftformat &> /dev/null; then
  echo "warning: SwiftFormat not installed. Please install it with: brew install swiftformat"
  exit 1
fi

# Set default Swift version if not provided
: "${SWIFT_VERSION:=6.0}"
echo "info: Using Swift version $SWIFT_VERSION for formatting"

# Find changed Swift files within any directory path containing 'Sources'
changed_files=$(git diff --diff-filter=d --name-only | grep 'Sources/.*\.swift$')

# Check if there are any changed Swift files in paths containing 'Sources'
if [ -z "$changed_files" ]; then
  echo "info: No changed Swift files in paths containing 'Sources' to format."
  exit 0
fi

# Count the number of files to format
file_count=$(echo "$changed_files" | wc -l | tr -d ' ')

# Use singular or plural form based on file count
if [ "$file_count" -eq 1 ]; then
  echo "info: Running SwiftFormat on 1 changed file in paths containing 'Sources'..."
else
  echo "info: Running SwiftFormat on $file_count changed files in paths containing 'Sources'..."
fi

# Run SwiftFormat on all changed files
swiftformat $(echo "$changed_files") --swiftversion "$SWIFT_VERSION"
