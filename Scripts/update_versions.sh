#!/bin/bash

# Script to update MARKETING_VERSION and CURRENT_PROJECT_VERSION in .xcconfig files

# --- Configuration ---
APP_XCCONFIG="xcconfigs/App.xcconfig"
FRAMEWORK_XCCONFIG="xcconfigs/Framework.xcconfig"
VERBOSE=false

# --- Helper Functions ---

# Function to log messages
log() {
  if [ "$VERBOSE" = true ]; then
    echo "$1"
  fi
}

# Function to update a key-value pair in an .xcconfig file
# $1: file_path
# $2: key
# $3: new_value
update_xcconfig_value() {
  local file_path="$1"
  local key="$2"
  local new_value="$3"

  if [ ! -f "$file_path" ]; then
    echo "Error: $file_path not found!"
    exit 1
  fi

  # Check if the key exists
  if grep -q -E "^${key}[[:space:]]*=" "$file_path"; then
    # macOS sed requires -i '' for in-place editing without backup
    sed -i '' "s|^${key}[[:space:]]*=.*|${key} = ${new_value}|" "$file_path"
    log "Updated $key to $new_value in $file_path"
  else
    echo "Warning: Key $key not found in $file_path. Appending it."
    echo "${key} = ${new_value}" >> "$file_path"
  fi
}

# --- Argument Parsing ---
USER_MARKETING_VERSION=""

while getopts ":m:v" opt; do
  case ${opt} in
    m )
      USER_MARKETING_VERSION=$OPTARG
      ;;
    v )
      VERBOSE=true
      ;;
    ? )
      echo "Usage: $0 [-m MARKETING_VERSION] [-v]"
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# --- Read Current Versions (from App.xcconfig as baseline) ---
if [ ! -f "$APP_XCCONFIG" ]; then
  echo "Error: $APP_XCCONFIG not found! Cannot determine current versions."
  exit 1
fi

CURRENT_MARKETING_VERSION_LOCAL=$(grep -E "^MARKETING_VERSION[[:space:]]*=" "$APP_XCCONFIG" | sed 's/MARKETING_VERSION[[:space:]]*=[[:space:]]*//' | tr -d '[:space:]')
CURRENT_BUILD_NUMBER_LOCAL_STR=$(grep -E "^CURRENT_PROJECT_VERSION[[:space:]]*=" "$APP_XCCONFIG" | sed 's/CURRENT_PROJECT_VERSION[[:space:]]*=[[:space:]]*//' | tr -d '[:space:]')

if ! [[ "$CURRENT_BUILD_NUMBER_LOCAL_STR" =~ ^[0-9]+$ ]]; then
  echo "Error: Could not parse CURRENT_PROJECT_VERSION from $APP_XCCONFIG as a number. Found: '$CURRENT_BUILD_NUMBER_LOCAL_STR'"
  CURRENT_BUILD_NUMBER_LOCAL=0 # Default to 0 if not parsable, or handle error more strictly
else
  CURRENT_BUILD_NUMBER_LOCAL=$((CURRENT_BUILD_NUMBER_LOCAL_STR))
fi


# --- Determine New Marketing Version ---
NEW_MARKETING_VERSION=""
if [ -n "$USER_MARKETING_VERSION" ]; then
  NEW_MARKETING_VERSION="$USER_MARKETING_VERSION"
  log "Using user-supplied Marketing Version: $NEW_MARKETING_VERSION"
else
  log "Auto-generating Marketing Version (CalVer YY.MM.release)..."
  TODAY_YY_MM=$(date "+%y.%m")
  
  # CalVer generation is based on the local App.xcconfig version.
  if [[ -n "$CURRENT_MARKETING_VERSION_LOCAL" ]] && [[ "$CURRENT_MARKETING_VERSION_LOCAL" == $TODAY_YY_MM* ]]; then
    # Current local version is from today's YY.MM, increment release number
    local_prefix=$(echo "$CURRENT_MARKETING_VERSION_LOCAL" | cut -d. -f1,2)
    local_release_num_str=$(echo "$CURRENT_MARKETING_VERSION_LOCAL" | cut -d. -f3)
    
    if [[ "$local_prefix" == "$TODAY_YY_MM" ]] && [[ "$local_release_num_str" =~ ^[0-9]+$ ]]; then
      next_release_num=$((local_release_num_str + 1))
      NEW_MARKETING_VERSION="${TODAY_YY_MM}.${next_release_num}"
    else
      # Fallback if parsing fails or prefix doesn't match somehow
      NEW_MARKETING_VERSION="${TODAY_YY_MM}.1"
    fi
  else
    # No local version for today's YY.MM, or local version is empty/malformed, start with .1
    NEW_MARKETING_VERSION="${TODAY_YY_MM}.1"
  fi
  log "Auto-generated Marketing Version: $NEW_MARKETING_VERSION"
fi

# --- Determine New Current Project Version (Build Number) ---
# Incrementing the local build number:
NEW_CURRENT_PROJECT_VERSION=$((CURRENT_BUILD_NUMBER_LOCAL + 1))
log "Incrementing local Current Project Version. New value: $NEW_CURRENT_PROJECT_VERSION"


# --- Update .xcconfig Files ---
echo "Updating versions..."
echo "  New Marketing Version:     $NEW_MARKETING_VERSION"
echo "  New Current Project Version: $NEW_CURRENT_PROJECT_VERSION"

update_xcconfig_value "$APP_XCCONFIG" "MARKETING_VERSION" "$NEW_MARKETING_VERSION"
update_xcconfig_value "$APP_XCCONFIG" "CURRENT_PROJECT_VERSION" "$NEW_CURRENT_PROJECT_VERSION"

update_xcconfig_value "$FRAMEWORK_XCCONFIG" "MARKETING_VERSION" "$NEW_MARKETING_VERSION"
update_xcconfig_value "$FRAMEWORK_XCCONFIG" "CURRENT_PROJECT_VERSION" "$NEW_CURRENT_PROJECT_VERSION"

echo "Version update complete."

exit 0 