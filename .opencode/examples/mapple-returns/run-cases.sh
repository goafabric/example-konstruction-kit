#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_DIR="$SCRIPT_DIR/testdata/cases"
RESULTS_DIR="$SCRIPT_DIR/results"

mkdir -p "$RESULTS_DIR"

for case_file in "$CASES_DIR"/*.md; do
  case_id="$(basename "$case_file" .md)"
  report="$RESULTS_DIR/$case_id.md"

  echo "==> $case_id"
  opencode run --agent mapple-returns "Process $case_file"

  if [[ -f "$report" ]]; then
    grep -E '^(Status|Reason):' "$report" || true
  else
    echo "No report written for $case_id" >&2
  fi

  echo
done
