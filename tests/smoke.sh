#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TRANS="$ROOT_DIR/trans"
PYTHON="$ROOT_DIR/.venv/bin/python3"
EXAMPLE="$SCRIPT_DIR/smoke-example.mp3"
TMP=$(mktemp -d)
PASS=0
FAIL=0

GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'

pass() { echo -e "${GREEN}✓ $1${NC}"; PASS=$((PASS + 1)); }
fail() { echo -e "${RED}✗ $1${NC}"; FAIL=$((FAIL + 1)); }

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

if [ ! -f "$EXAMPLE" ]; then
    echo "Missing test file: $EXAMPLE"
    exit 1
fi

# ── Free tests ────────────────────────────────────────────────────────────

echo "── Free tests ──"

if "$TRANS" --help > /dev/null 2>&1; then pass "--help / -h"; else fail "--help / -h"; fi

OUT="$TMP/dryrun.txt"
"$TRANS" -n "$EXAMPLE" -o "$OUT" > /dev/null 2>&1
if [ ! -f "$OUT" ]; then pass "--dry-run: no output file created"; else fail "--dry-run: no output file created"; fi

# ── Cost estimate ─────────────────────────────────────────────────────────

API_SCENARIOS=6
# Inline Python reuses the same mutagen library as trans — guarantees identical duration math.
COST=$("$PYTHON" - "$EXAMPLE" "$API_SCENARIOS" <<'EOF'
import math, sys
from mutagen import File
duration = File(sys.argv[1]).info.length
n = int(sys.argv[2])
print(f"{math.ceil(duration / 60) * 0.006 * n:.4f}")
EOF
)

echo ""
echo "── API tests ($API_SCENARIOS calls, estimated cost: ~\$$COST) ──"
read -rp "Proceed? [y/N] " confirm
[[ "$confirm" != "y" ]] && echo "Aborted." && exit 0
echo ""

# ── API tests ─────────────────────────────────────────────────────────────

# basic
OUT="$TMP/basic.txt"
if "$TRANS" -y "$EXAMPLE" --lang ru -o "$OUT" > /dev/null 2>&1 && [ -s "$OUT" ]; then
    pass "basic transcription"
else
    fail "basic transcription"
fi

# --output / -o
OUT="$TMP/output.txt"
if "$TRANS" -y "$EXAMPLE" --lang ru -o "$OUT" > /dev/null 2>&1 && [ -s "$OUT" ]; then
    pass "--output / -o"
else
    fail "--output / -o"
fi

# --lang
OUT="$TMP/lang.txt"
if "$TRANS" -y "$EXAMPLE" --lang ru -o "$OUT" > /dev/null 2>&1 && [ -s "$OUT" ]; then
    pass "--lang ru"
else
    fail "--lang ru"
fi

# --live
OUT="$TMP/live.txt"
STDOUT=$("$TRANS" -y "$EXAMPLE" --lang ru --live -o "$OUT" 2>/dev/null)
if [ -s "$OUT" ] && [ -n "$STDOUT" ]; then
    pass "--live (transcript printed to stdout)"
else
    fail "--live"
fi

# --quiet
OUT="$TMP/quiet.txt"
STDOUT=$("$TRANS" -q "$EXAMPLE" --lang ru -o "$OUT" 2>/dev/null)
if [ -s "$OUT" ] && [ -z "$STDOUT" ]; then
    pass "--quiet (no stdout, file written)"
else
    fail "--quiet"
fi

# --model
OUT="$TMP/model.txt"
if "$TRANS" -y "$EXAMPLE" --lang ru --model whisper-1 -o "$OUT" > /dev/null 2>&1 && [ -s "$OUT" ]; then
    pass "--model whisper-1"
else
    fail "--model whisper-1"
fi

# ── Summary ───────────────────────────────────────────────────────────────

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
