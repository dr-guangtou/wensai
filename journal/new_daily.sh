#!/usr/bin/env bash
# Create today's daily journal note from the vault template.
# Safe: exits without writing if the note already exists.

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TODAY=$(date +%Y-%m-%d)
YEAR=$(date +%Y)

DEST_DIR="$VAULT_ROOT/journal/$YEAR"
DEST_FILE="$DEST_DIR/$TODAY.md"
TEMPLATE="$VAULT_ROOT/templates/template_journal.md"

if [[ -f "$DEST_FILE" ]]; then
    echo "Already exists: $DEST_FILE"
    exit 0
fi

mkdir -p "$DEST_DIR"
sed "s/{{date}}/$TODAY/g" "$TEMPLATE" > "$DEST_FILE"
echo "Created: $DEST_FILE"
