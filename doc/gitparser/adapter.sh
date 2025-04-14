#!/bin/bash

GITHUB_URL="https://github.com/goafabric"
WORKDIR="/tmp/repos"  # Temporary directory to clone repositories
REPOLIST="$(pwd)/repos.txt"  # List of repositories

# Ensure the working directory exists
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

# Loop through each repository in repos.txt
while read -r repo; do
    echo "Processing repository: $repo"

    # Clone the repository (shallow clone for speed)
    git clone --depth 1 "$GITHUB_URL/$repo.git" "$repo" 2>/dev/null

    # Navigate into the repository
    cd "$repo" || continue

    # Ensure we are on the main branch
    git checkout main 2>/dev/null || git checkout master 2>/dev/null

    # Check if application.yaml exists
    FILE="src/main/resources/application.yml"
    if [[ -f "$FILE" ]]; then
         echo "Found inside $repo"

         # Extract the adapter block and process it:
         sed -n '/^adapter:/,/^[^ ]/p' "$FILE" | \
         awk '
             function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
             BEGIN { current_service="" }
             # Look for a key at 2-space indent that is “empty” (ends with a colon only)
             /^[ \t]{2}[a-zA-Z0-9_-]+:[ \t]*$/ {
                 key = trim($0)
                 sub(/:$/, "", key)
                 # Skip common non-service keys (like "timeout")
                 if (key != "timeout") {
                     current_service = key
                 } else {
                     current_service = ""
                 }
                 next
             }
             # Look for a line at 4-space indent starting with "url:"
             /^[ \t]{4}url:[ \t]*/ {
                 if (current_service != "") {
                     line = trim($0)
                     sub(/^url:[ \t]*/, "", line)
                     print "adapter." current_service ".url=" line
                 }
             }
         '
         echo "-------------------------"
     fi

    # Cleanup and move back
    cd "$WORKDIR"
    rm -rf "$repo"  # Remove cloned repo to save space
done < "$REPOLIST"
