#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/trans"

mkdir -p "$BIN_DIR"

ln -sf "$REPO_DIR/trans" "$TARGET"
echo "Symlink created: $TARGET -> $REPO_DIR/trans"

if ! grep -q '# BEGIN transcribe-whisper' "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# BEGIN transcribe-whisper
export PATH="$HOME/.local/bin:$PATH"
# END transcribe-whisper
EOF
    echo "Added ~/.local/bin to PATH in ~/.bashrc"
else
    echo "~/.local/bin already configured in ~/.bashrc, skipping"
fi

echo "Done. Open a new terminal to use 'trans', or: source ~/.bashrc"
