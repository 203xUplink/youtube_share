#!/bin/bash

SESSION="llm"
WORKDIR="$PWD"  # Remember where user started script

# Create tmux session detached at current dir
tmux new-session -d -s $SESSION -c "$WORKDIR" "gemini"

# Create additional panes in same directory
tmux split-window -h -t $SESSION -c "$WORKDIR" "claude"
tmux split-window -h -t $SESSION -c "$WORKDIR" "codex"

tmux select-layout -t $SESSION even-horizontal

tmux attach -t $SESSION

