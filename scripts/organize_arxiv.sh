#!/usr/bin/env bash
# Organize arXiv digest notes into the correct YYYY/MM/arxiv-YYYY-MM-DD.md structure.
#
# Finds all Markdown files under papers/arxiv/ whose filename contains a YYYY-MM-DD
# date pattern (with or without the "arxiv-" prefix). If a file is not at
# YYYY/MM/arxiv-YYYY-MM-DD.md relative to this script's directory, it is moved there.
#
# Usage:
#   bash scripts/organize_arxiv.sh           # dry-run (default)
#   bash scripts/organize_arxiv.sh --apply   # actually move files

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BASE_DIR="$VAULT_ROOT/papers/arxiv"
DRY_RUN=true

if [[ "${1:-}" == "--apply" ]]; then
    DRY_RUN=false
fi

moved=0
skipped=0
already_correct=0
conflicts=0

while IFS= read -r filepath; do
    filename=$(basename "$filepath")

    # Extract YYYY-MM-DD from the filename (handles both "arxiv-2026-03-05.md"
    # and bare "2026-03-05.md" patterns).
    if [[ "$filename" =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"
    else
        continue
    fi

    correct_name="arxiv-${year}-${month}-${day}.md"
    correct_dir="${BASE_DIR}/${year}/${month}"
    correct_path="${correct_dir}/${correct_name}"

    # Already in the right place with the right name.
    if [[ "$filepath" == "$correct_path" ]]; then
        ((already_correct += 1))
        continue
    fi

    # Conflict: correct destination already has a file.
    if [[ -f "$correct_path" ]]; then
        echo "CONFLICT: $filepath -> $correct_path (destination exists, skipping)"
        ((conflicts += 1))
        continue
    fi

    # Move (or preview).
    rel_src="${filepath#"$BASE_DIR"/}"
    rel_dst="${correct_path#"$BASE_DIR"/}"

    if $DRY_RUN; then
        echo "  would move: $rel_src -> $rel_dst"
    else
        mkdir -p "$correct_dir"
        mv "$filepath" "$correct_path"
        echo "  moved: $rel_src -> $rel_dst"
    fi
    ((moved += 1))

done < <(find "$BASE_DIR" -name "*.md" -type f | sort)

echo ""
if $DRY_RUN; then
    echo "[DRY RUN] $moved to move, $already_correct already correct, $conflicts conflicts."
    if (( moved > 0 )); then
        echo "Run with --apply to move files."
    fi
else
    echo "Done: $moved moved, $already_correct already correct, $conflicts conflicts."
fi
