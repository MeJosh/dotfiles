#!/bin/bash

# Example command to run: 
# open -na ghostty --args --title "Project Picker" -e "$(echo ~/Projects/dotfiles/scripts/open_project.sh)"

# Define the directory to search
SEARCH_DIR="$HOME/Projects"

# List directories/files in the SEARCH_DIR and pass them to fzf
SELECTED=$(find "$SEARCH_DIR" -mindepth 1 -maxdepth 1 | fzf)

# If a selection was made, open it in the file explorer
if [ -n "$SELECTED" ]; then
  if command -v xdg-open &> /dev/null; then
    xdg-open "$SELECTED"  # Linux
  elif command -v open &> /dev/null; then
    open "$SELECTED"      # macOS
  else
    echo 'No file explorer command found (xdg-open or open).' >&2
    exit 1
  fi
else
  echo 'No selection made.' >&2
fi

# Close the terminal after completion
exit

