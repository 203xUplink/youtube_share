# TMUX Multi Agent Session Prompt

## Purpose
Starting point for managing the multi-agent tmux session (Codex + Claude + Gemini) in this vault.

## Session setup (from `start_llm_tmux.sh`)
- Session name: `llm`
- Pane layout: vertical stack with 3 panes
  - Pane 0 (top): Codex (this agent)
  - Pane 1 (middle): Claude
  - Pane 2 (bottom): Gemini
- Titles set in tmux for quick identification

## How to message agents (tmux)
- Send text to Claude (pane 1):
  - `tmux send-keys -t llm:0.1 "<message>" C-m`
- Send text to Gemini (pane 2):
  - `tmux send-keys -t llm:0.2 "<message>" C-m`
- If the prompt appears but isn’t submitted, send an extra Enter:
  - `tmux send-keys -t llm:0.1 C-m` or `tmux send-keys -t llm:0.2 C-m`
- If you see the message echoed twice or the input box is still active, send one more Enter to submit.
 - Default behavior: send Enter twice immediately after each message to ensure submission.
 - Reliable send pattern (use every time): run two shell commands with a small delay in between.
   - Example (Gemini):
     - `tmux send-keys -t llm:0.2 "<message>" C-m; sleep 0.2; tmux send-keys -t llm:0.2 C-m`
   - Example (Claude):
     - `tmux send-keys -t llm:0.1 "<message>" C-m; sleep 0.2; tmux send-keys -t llm:0.1 C-m`

## Quick verify (did it submit?)
- Capture the last lines and confirm the prompt is no longer in the input box:
  - `tmux capture-pane -t llm:0.2 -p | tail -n 40`

## How to read responses
- Claude:
  - `tmux capture-pane -t llm:0.1 -p | tail -n 40`
- Gemini:
  - `tmux capture-pane -t llm:0.2 -p | tail -n 80`

## Notes from last check
- Claude responded with context: Obsidian vault for research group, no build system, and specialized agents (YouTube production, vault maintenance, todo management).
- Gemini responded with context: Obsidian vault with many Markdown notes and MOC files; noticed `CLAUDE.md` and `.claude/`.

## Reminder
- tmux socket access may require escalated permissions (socket in `/tmp`).

## Interaction cadence
- Use back-and-forth communication: query each agent at least two times before consolidating the final answer.
