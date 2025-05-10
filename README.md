# Dotfiles

## Setup

### Downloading

Clone the repo to a location of your choice (e.g. `~/Projects/dotfiles`):

```sh
git clone git@github.com:MeJosh/dotfiles.git ~/Projects/dotfiles
```

### Installation

All installation steps are automated in the `scripts/install.sh` wrapper. This will:

1. Bootstrap Homebrew (if not already installed)
2. Install or update all packages from the `Brewfile` via `brew bundle`
3. Link your dotfiles into your home directory using GNU stow

To run the installer:

```sh
# Make sure helper scripts are executable
chmod +x ~/Projects/dotfiles/scripts/*.sh

# Run the install script (defaults to stowing "git" – see scripts/install.sh for how to customize packages)
~/Projects/dotfiles/scripts/install.sh
```

If you want to stow additional packages (sub‑folders in your dotfiles repo), pass them as arguments:

```sh
~/Projects/dotfiles/scripts/install.sh zsh vim tmux
```

---

## Updating

Keep your dotfiles, Homebrew packages, and stows all up to date with a single command:

```sh
~/Projects/dotfiles/scripts/update.sh
```

This will:

1. Pull the latest changes from the dotfiles repo
2. Run `brew update && brew upgrade` to update Homebrew itself and all installed formulae
3. Re-run `install.sh` to reapply stows and sync any changes

---

## CLI Helper

After installation, you can use the `dotfiles` convenience command in your shell for quick routines:

```sh
dotfiles install        # bootstrap Homebrew, run brew bundle, and stow default packages

dotfiles update         # pull repo updates, upgrade brew packages, and re-stow

dotfiles stow <package> # link a specific stow module (e.g. git, ohmyzsh)
```

Make sure to reload your shell or run `source ~/.zshrc` if you update `~/.zshrc` with the helper function.

