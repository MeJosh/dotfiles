#!/bin/bash

# Default to the current working directory if no argument is provided
directory=${1:-$(pwd)}

# Parse named arguments
recursive=false
filter="all"
show_help=false
for arg in "$@"; do
    if [[ "$arg" == "--recursive" ]]; then
        recursive=true
    elif [[ "$arg" == "--filter="* ]]; then
        filter="${arg#--filter=}"
    elif [[ "$arg" == "--help" ]]; then
        show_help=true
    fi
done

# Function to display help information
show_help_message() {
    echo "Usage: gitstatus.sh [directory] [options]"
    echo ""
    echo "Description:"
    echo "  This script scans a directory for Git repositories and displays their status."
    echo "  It provides information about the branch, uncommitted changes, and whether"
    echo "  the repository is ahead or behind the origin."
    echo ""
    echo "Options:"
    echo "  --recursive       Recursively search for Git repositories in subdirectories."
    echo "  --filter=<value>  Filter repositories based on their status. Supported values:"
    echo "                    - all: List all repositories (default)."
    echo "                    - ahead: List repositories ahead of the origin."
    echo "                    - behind: List repositories behind the origin."
    echo "                    - uncommitted: List repositories with uncommitted changes."
    echo "                    - clean: List repositories that are up-to-date."
    echo "                    - dirty: List repositories that are either ahead, behind, or uncommitted."
    echo "  --help            Display this help message."
    echo ""
    echo "Examples:"
    echo "  ./gitstatus.sh ~/Projects --recursive"
    echo "  ./gitstatus.sh ~/Projects --filter=uncommitted"
    echo "  ./gitstatus.sh ~/Projects --filter=dirty --recursive"
    exit 0
}

# Show help message if --help is provided
if [ "$show_help" == true ]; then
    show_help_message
fi

# Start the timer
SECONDS=0

# Initialize repository count
repo_count=0

# Define color codes (compatible with zsh and bash)
GREEN=$'\e[32m'
RED=$'\e[31m'
PURPLE=$'\e[35m'
YELLOW=$'\e[33m'
BOLD=$'\e[1m'
RESET=$'\e[0m'

# Function to recursively search for .git directories
find_git_repos() {
    local dir="$1"
    # Loop through all directories and files in the current directory
    for item in "$dir"/*; do
        # Check if the item is a directory
        if [ -d "$item" ]; then
            # Check if the directory contains a .git folder
            if [ -d "$item/.git" ]; then
                # Run `git status` and extract information
                cd "$item" || continue
                branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
                updated_files=$(git status --porcelain | wc -l)
                clean_status=$(git status --porcelain | grep -q . && echo "Uncommitted" || echo "Clean")
                
                # Check ahead/behind status
                ahead_count=$(git rev-list --count "${branch}".."origin/${branch}" 2>/dev/null || echo 0)
                behind_count=$(git rev-list --count "origin/${branch}".."${branch}" 2>/dev/null || echo 0)
                ahead_behind=""
                if [ "$ahead_count" -gt 0 ]; then
                    ahead_behind="${ahead_count} commits ${RED}ahead${RESET} origin"
                fi
                if [ "$behind_count" -gt 0 ]; then
                    if [ -n "$ahead_behind" ]; then
                        ahead_behind="${ahead_behind}, ${behind_count} commits ${RED}behind${RESET} origin"
                    else
                        ahead_behind="${behind_count} commits ${RED}behind${RESET} origin"
                    fi
                fi

                # Determine the status icon color
                if [ "$clean_status" == "Clean" ] && [ "$ahead_count" -eq 0 ] && [ "$behind_count" -eq 0 ]; then
                    status_icon="${GREEN}[✓]${RESET}"
                else
                    status_icon="${RED}[✗]${RESET}"
                fi
                
                # Determine the branch name color
                if [[ "$branch" == "main" || "$branch" == "master" ]]; then
                    branch_color="${PURPLE}${branch}${RESET}"
                else
                    branch_color="${YELLOW}${branch}${RESET}"
                fi
                
                # Trim the directory path to show relative to the input directory
                relative_path=${item#$directory/}
                relative_path="${BOLD}${relative_path}${RESET}" # Make the project path bold

                # Apply filter logic
                case "$filter" in
                    "all")
                        show_repo=true
                        ;;
                    "ahead")
                        show_repo=$([ "$ahead_count" -gt 0 ] && echo true || echo false)
                        ;;
                    "behind")
                        show_repo=$([ "$behind_count" -gt 0 ] && echo true || echo false)
                        ;;
                    "uncommitted")
                        show_repo=$([ "$clean_status" == "Uncommitted" ] && echo true || echo false)
                        ;;
                    "clean")
                        show_repo=$([ "$clean_status" == "Clean" ] && [ "$ahead_count" -eq 0 ] && [ "$behind_count" -eq 0 ] && echo true || echo false)
                        ;;
                    "dirty")
                        show_repo=$([ "$clean_status" == "Uncommitted" ] || [ "$ahead_count" -gt 0 ] || [ "$behind_count" -gt 0 ] && echo true || echo false)
                        ;;
                    *)
                        echo "Invalid filter: $filter"
                        exit 1
                        ;;
                esac

                # Display repository details if it matches the filter
                if [ "$show_repo" == "true" ]; then
                    repo_count=$((repo_count + 1))
                    printf "%02d. %s %s (%s)\n" "$repo_count" "$status_icon" "$relative_path" "$branch_color"
                    if [ "$clean_status" == "Uncommitted" ]; then
                        printf "  └ %d ${RED}updated${RESET} files\n" "$updated_files"
                    fi
                    if [ -n "$ahead_behind" ]; then
                        printf "  └ %s\n" "$ahead_behind"
                    fi
                fi

                # If recursive is false, skip further recursion for this directory
                if [ "$recursive" == false ]; then
                    continue
                fi
            fi
            # Recursively call the function for subdirectories
            find_git_repos "$item"
        fi
    done
}

# Start the search from the provided or default directory
find_git_repos "$directory"

# Calculate the elapsed time
elapsed_seconds=$SECONDS
minutes=$((elapsed_seconds / 60))
seconds=$((elapsed_seconds % 60))

# Print the summary
echo "----------------------------------------"
echo "$repo_count repositories found."
printf "Search completed in %02d:%02d\n" "$minutes" "$seconds"
