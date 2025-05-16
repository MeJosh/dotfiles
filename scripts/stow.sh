#!/usr/bin/env bash
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────

# Script is now in ~/Projects/dotfiles/scripts, so repo root is one level up
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Always link into your home directory
TARGET_DIR="$HOME"

# ─── Check dependencies & args ─────────────────────────────────────────────────

if ! command -v stow &>/dev/null; then
  echo "❌  GNU stow not found. Install with e.g. ‘brew install stow’" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") <package> [package…]" >&2
  exit 1
fi

# ─── Do the stow ───────────────────────────────────────────────────────────────

cd "$DOTFILES_ROOT"
for pkg in "$@"; do
  echo "👉  stowing '$pkg' → $TARGET_DIR"
  stow "$pkg" --target="$TARGET_DIR" --adopt --dotfiles
done

echo "✅  Done."

