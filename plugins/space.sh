#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh" # Loads all defined colors

sid="${NAME#space.}"

focused_workspace="$FOCUSED_WORKSPACE"

if [ -z "$focused_workspace" ]; then
	focused_workspace="$(aerospace list-workspaces --focused 2>/dev/null)"
fi

if [ "$sid" = "$focused_workspace" ]; then
	sketchybar --animate tanh 5 --set "$NAME" \
		icon.color="$RED" \
		icon="$sid"
else
	sketchybar --animate tanh 5 --set "$NAME" \
		icon.color="$COMMENT" \
		icon="$sid"
fi
