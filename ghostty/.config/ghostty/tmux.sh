#!/bin/bash
SESSION_NAME="ghostty"

[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -n "$TMUX" ]; then
    exec "$SHELL" -l
    exit
fi

if ! command -v tmux >/dev/null 2>&1; then
    exec $SHELL -l
    exit
fi

TMUX_VERSION=$(tmux -V | cut -d' ' -f2)
if [ "$TMUX_VERSION" != "3.5a" ]; then
    exec "$SHELL" -l
    exit
fi

# Check if the session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -eq 0 ]; then
 # If the session exists, reattach to it
 tmux attach-session -t $SESSION_NAME
else
 # If the session doesn't exist, start a new one
 tmux new-session -s $SESSION_NAME -d
 tmux attach-session -t $SESSION_NAME
fi
