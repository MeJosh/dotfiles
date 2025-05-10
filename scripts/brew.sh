# ~/Projects/dotfiles/scripts/brew.sh
#!/usr/bin/env bash
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────

# Repo root is one level up from this script
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Path to a Brewfile in your repo (if you use one)
BUNDLE_FILE="$DOTFILES_ROOT/Brewfile"

# ─── Dependency check ──────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
  echo "❌  Homebrew not found. Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ─── Install packages ─────────────────────────────────────────────────────────

if [[ -f "$BUNDLE_FILE" ]]; then
  echo "💧  Running brew bundle → $BUNDLE_FILE"
  brew bundle --file="$BUNDLE_FILE"
else
  if [[ $# -lt 1 ]]; then
    echo "Usage: $(basename "$0") <formula> [formula…]" >&2
    exit 1
  fi
  for pkg in "$@"; do
    echo "💧  brew install $pkg"
    brew install "$pkg"
  done
fi

echo "✅  brew.sh complete."
