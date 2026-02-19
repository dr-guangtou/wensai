#!/usr/bin/env bash
# Sync arXiv digest notes from yuzhe/project1 into wensai/papers/arxiv.
# Files that already exist in the destination are skipped.
#
# Source: yuzhe/project1/arxiv_digest/archive/YYYY/YYYY-MM-DD.md
# Dest:   wensai/papers/arxiv/YYYY/YYYY-MM-DD.md

set -euo pipefail

SOURCE_DIR="/Users/mac/Dropbox/work/project/vibe/yuzhe/project1/arxiv_digest/archive"
DEST_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: source directory not found: $SOURCE_DIR" >&2
    exit 1
fi

synced=0
skipped=0

for src_file in "$SOURCE_DIR"/*/*.md; do
    year=$(basename "$(dirname "$src_file")")
    filename=$(basename "$src_file")
    dest_file="$DEST_DIR/$year/$filename"

    if [[ -f "$dest_file" ]]; then
        ((skipped += 1))
        continue
    fi

    mkdir -p "$DEST_DIR/$year"
    cp "$src_file" "$dest_file"
    echo "Synced: $year/$filename"
    ((synced += 1))
done

echo ""
echo "Done: $synced synced, $skipped skipped."
