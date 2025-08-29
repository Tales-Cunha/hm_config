#!/usr/bin/env bash

# Exit on any error
set -e

# Get target directory
if [[ $# -eq 1 ]]; then
    selected="$1"
else
    # Simple, unified directory search
    selected=$(find ~/projects ~/work ~/personal ~/.config ~/Documents ~/ \
        -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | fzf --height=40%)
fi

# Exit if no selection
[[ -z "$selected" ]] && exit 0

# Clean session name
session_name=$(basename "$selected" | tr '. ' '_-')

# Create session if it doesn't exist
if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

# Attach or switch to session
if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
