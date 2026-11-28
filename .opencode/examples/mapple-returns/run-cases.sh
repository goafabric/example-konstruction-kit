#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_DIR="$SCRIPT_DIR/testdata/cases"
RESULTS_DIR="$SCRIPT_DIR/results"
MODEL="${MAPPLE_MODEL:-openrouter/deepseek/deepseek-v4.1-flash-1017}"

mkdir -p "$RESULTS_DIR"

echo "Model: $MODEL"

for case_file in "$CASES_DIR"/*.md; do
  case_id="$(basename "$case_file" .md)"
  report="$RESULTS_DIR/$case_id.md"

  echo "==> $case_id"
  opencode run --agent mapple-returns --model "$MODEL" --auto "Process $case_file"

  if [[ -f "$report" ]]; then
    grep -E '^(Status|Reason):' "$report" || true
  else
    echo "No report written for $case_id" >&2
  fi

  echo
done
