#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HELPER_DIR/aerospace.sh"

sid="${NAME#space.}"

restore_workspace_colors() {
	focused_workspace="$(aerospace_focused_workspace "$FOCUSED_WORKSPACE")"
	workspaces="$(aerospace_all_workspaces)"

	if [ "$workspaces" = "" ]; then
		if [ "$sid" = "$focused_workspace" ]; then
			sketchybar --animate tanh "$WORKSPACE_TRANSITION" --set "$NAME" \
				icon.color="$WORKSPACE_ACTIVE_COLOR" \
				icon="$sid"
		else
			sketchybar --animate tanh "$WORKSPACE_TRANSITION" --set "$NAME" \
				icon.color="$WORKSPACE_INACTIVE_COLOR" \
				icon="$sid"
		fi
		return
	fi

	printf '%s\n' "$workspaces" | while IFS= read -r workspace_id; do
		[ -z "$workspace_id" ] && continue

		if [ "$workspace_id" = "$focused_workspace" ]; then
			sketchybar --animate tanh "$WORKSPACE_TRANSITION" --set "space.$workspace_id" \
				icon.color="$WORKSPACE_ACTIVE_COLOR" \
				icon="$workspace_id"
		else
			sketchybar --animate tanh "$WORKSPACE_TRANSITION" --set "space.$workspace_id" \
				icon.color="$WORKSPACE_INACTIVE_COLOR" \
				icon="$workspace_id"
		fi
	done
}

if [ "$SENDER" = "mouse.entered" ]; then
	restore_workspace_colors
	sketchybar --animate tanh "$HOVER_ANIMATION_DURATION" --set "$NAME" \
		icon.color="$WORKSPACE_HOVER_COLOR"
	exit 0
fi

if [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
	restore_workspace_colors
	exit 0
fi

focused_workspace="$(aerospace_focused_workspace "$FOCUSED_WORKSPACE")"

if [ "$sid" = "$focused_workspace" ]; then
	sketchybar --animate tanh "$WORKSPACE_TRANSITION" --set "$NAME" \
		icon.color="$WORKSPACE_ACTIVE_COLOR" \
		icon="$sid"
else
	sketchybar --animate tanh "$WORKSPACE_TRANSITION" --set "$NAME" \
		icon.color="$WORKSPACE_INACTIVE_COLOR" \
		icon="$sid"
fi
