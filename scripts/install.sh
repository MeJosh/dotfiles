#!/usr/bin/env bash
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────

# Repo root is one level up from this script
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$DOTFILES_ROOT/scripts"

# ─── Make sure all your helper scripts are executable ──────────────────────────

echo "🔧  Making all scripts in $SCRIPTS_DIR executable"
chmod +x "$SCRIPTS_DIR"/*.sh

# ─── Ensure Homebrew is installed ──────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
  echo "🍺  Homebrew not found. Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ─── Default packages to stow ─────────────────────────────────────────────────

# Edit this list to add more stow “packages” by folder-name
PACKAGES=(git)

# If user passed package names, override the default
if [[ $# -gt 0 ]]; then
  PACKAGES=("$@")
fi

# ─── Sanity checks ────────────────────────────────────────────────────────────

for script in brew.sh stow.sh; do
  if [[ ! -x "$SCRIPTS_DIR/$script" ]]; then
    echo "❌  Can't find executable $script in $SCRIPTS_DIR" >&2
    exit 1
  fi
done

# ─── Run Homebrew installs ────────────────────────────────────────────────────

echo "🔄  Running brew.sh"
"$SCRIPTS_DIR/brew.sh"

# ─── Run stow for dotfiles ────────────────────────────────────────────────────

echo "🔄  Running stow.sh for packages: ${PACKAGES[*]}"
"$SCRIPTS_DIR/stow.sh" "${PACKAGES[@]}"

echo "🎉  install.sh complete."
