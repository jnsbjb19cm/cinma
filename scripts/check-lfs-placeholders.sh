#!/usr/bin/env bash

# Detect text files that contain Git LFS pointer stubs instead of real content.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLACEHOLDER_HEADER="version https://git-lfs.github.com/spec/v1"

TEXT_EXTENSIONS=(
  "js" "ts" "mjs" "cjs" "vue"
  "java" "kt" "xml" "properties" "iml"
  "yml" "yaml" "json" "md" "txt" "sql"
  "html" "htm" "css" "scss" "less"
  "gradle" "pom" "ini" "cfg"
)

is_text_file() {
  local file="$1"
  local ext="${file##*.}"
  for candidate in "${TEXT_EXTENSIONS[@]}"; do
    if [[ "$candidate" == "$ext" ]]; then
      return 0
    fi
  done
  return 1
}

echo "Scanning for Git LFS placeholders in text files..."

found_any=0
printed=0
max_print=50
while IFS= read -r -d '' file; do
  # Restrict to likely text files to avoid flagging binary assets.
  if ! is_text_file "$file"; then
    continue
  fi

  if head -n 1 "$file" 2>/dev/null | grep -q "$PLACEHOLDER_HEADER"; then
    rel_path="${file#$ROOT_DIR/}"
    if [[ $printed -lt $max_print ]]; then
      echo "⚠️  Placeholder detected: $rel_path"
      printed=$((printed + 1))
    fi
    found_any=1
  fi
done < <(find "$ROOT_DIR" \
  -path "$ROOT_DIR/.git" -prune -o \
  -path "$ROOT_DIR/node_modules" -prune -o \
  -path "$ROOT_DIR/.idea" -prune -o \
  -path "$ROOT_DIR/.mvn" -prune -o \
  -type f -print0)

if [[ $found_any -eq 1 ]]; then
  if [[ $printed -ge $max_print ]]; then
    echo "…output truncated after $max_print files."
  fi
  echo "One or more text files are still LFS pointers. Restore the real content before building."
  exit 1
else
  echo "No LFS pointer placeholders detected in tracked text files."
fi
