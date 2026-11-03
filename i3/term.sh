#!/usr/bin/env bash

TERM_CLASS="kitty"
TERM_CMD="kitty"

count=$(i3-msg -t get_tree | jq --arg c "$TERM_CLASS" '
  [ .. | objects
    | select(.type == "workspace" and .num == 5)
    | .. | objects
    | select(.window_properties?.class? == $c)
  ] | length')

i3-msg -q workspace number 5

if [ "$count" -eq 0 ]; then
    exec $TERM_CMD
fi
