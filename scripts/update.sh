#!/usr/bin/env bash
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────

# Repo root is one level up from this script
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$DOTFILES_ROOT/scripts"

# ─── Sanity checks ────────────────────────────────────────────────────────────

if [[ ! -x "$SCRIPTS_DIR/install.sh" ]]; then
  echo "❌  Can't find executable install.sh in $SCRIPTS_DIR" >&2
  exit 1
fi

# ─── Update dotfiles repository ───────────────────────────────────────────────

cd "$DOTFILES_ROOT"
echo "📦  Pulling latest changes"
git pull --ff-only

# ─── Update Homebrew itself & upgrade installed packages ───────────────────────

echo "🍺  Updating Homebrew"
brew update
brew upgrade

# ─── Re-run full install (brew bundle + stow) ──────────────────────────────────

echo "🔄  Running install.sh"
"$SCRIPTS_DIR/install.sh"

echo "✅  update.sh complete."

