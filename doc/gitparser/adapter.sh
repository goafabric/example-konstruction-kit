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
    git clone --depth 1 "$GITHUB_URL/$repo.git" "$repo"

    # Navigate into the repository
    cd "$repo" || continue

    # Ensure we are on the main branch
    git checkout main 2>/dev/null || git checkout master 2>/dev/null

    # Check if application.yaml exists
    FILE="src/main/resources/application.yml"
 if [[ -f "$FILE" ]]; then
        echo "Found $FILE in $repo"

        # Use sed and awk to process the YAML and extract `adapter.<service>.url`
        sed -n '/^adapter:/,/^[^ ]/p' "$FILE" | \
        awk '
            BEGIN {service=""}
            # Track the service name within adapter:
            /^[ \t]+[a-zA-Z0-9_-]+:/ {
                if ($1 ~ /:/) {
                    service=$1;
                    gsub(":", "", service);
                }
            }
            # Extract the `url` field under each service
            /^[ \t]+url:/ {
                gsub(/url:/, "", $0);
                gsub(/^[ \t]+/, "", $0);
                gsub(/\"/, "", $0);
                if (service != "") print "adapter." service ".url=" $0
            }
        '

        echo "-------------------------"
    fi
    # Cleanup and move back
    cd "$WORKDIR"
    rm -rf "$repo"  # Remove cloned repo to save space
done < "$REPOLIST"
