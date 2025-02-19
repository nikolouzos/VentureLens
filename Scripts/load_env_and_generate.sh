#!/bin/bash

# Define the path to the .env file relative to the script's location
ENV_FILE=".env"

echo "Looking for .env file at: $(pwd)/$ENV_FILE"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
    echo "✅ .env file found"
    echo "Contents of .env file (masked):"
    cat "$ENV_FILE" | sed 's/=.*/=****/'
    
    # Read the environment variables into a string to pass to tuist generate
    ENV_VARS=$(grep -v '^#' "$ENV_FILE" | xargs)
    
    echo "🔄 Running tuist generate with environment variables..."
    # Run tuist generate with the environment variables
    env $ENV_VARS tuist generate
else
    echo "❌ Error: .env file not found at $ENV_FILE"
    exit 1
fi
