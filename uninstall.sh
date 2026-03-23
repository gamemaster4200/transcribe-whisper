#!/usr/bin/env bash
set -e

TARGET="$HOME/.local/bin/trans"

if [ -L "$TARGET" ]; then
    rm "$TARGET"
    echo "Symlink removed: $TARGET"
else
    echo "No symlink found at $TARGET, skipping"
fi

BASHRC="$HOME/.bashrc"
if grep -q '# BEGIN transcribe-whisper' "$BASHRC" 2>/dev/null; then
    cp "$BASHRC" "$BASHRC.bak"
    echo "Backup created: $BASHRC.bak"
    sed -i '/# BEGIN transcribe-whisper/,/# END transcribe-whisper/d' "$BASHRC"
    echo "Removed PATH entry from $BASHRC"
else
    echo "No PATH entry found in $BASHRC, skipping"
fi

echo "Done."
