#!/bin/bash

# Add Homebrew binary paths to PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Navigate to the project root directory
cd "$(dirname "$0")/../../"

# Check if swiftformat is installed
if ! command -v swiftformat &> /dev/null; then
  echo "warning: SwiftFormat not installed. Please install it with: brew install swiftformat"
  exit 1
fi

# Find changed Swift files within any 'Sources' directory
changed_files=$(git diff --diff-filter=d --name-only | grep '^Sources/.*\.swift$')

# Check if there are any changed Swift files in 'Sources' directories
if [ -z "$changed_files" ]; then
  echo "info: No changed Swift files in 'Sources' directories to format."
  exit 0
fi

# Run SwiftFormat on each changed file
echo "info: Running SwiftFormat on changed files in 'Sources' directories..."
echo "$changed_files" | while IFS= read -r file; do
  if [ -f "$file" ]; then
    swiftformat "$file"
    echo "info: Formatted $file"
  fi
done

echo "info: SwiftFormat completed."
