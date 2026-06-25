#!/usr/bin/env bash

source "$HELPER_DIR/aerospace.sh"

sketchybar --add item spacer.1 left \
	--set spacer.1 background.drawing=off \
	label.drawing=off \
	icon.drawing=off \
	width="$WIDGET_SPACING"

WORKSPACES="$(aerospace_all_workspaces)"

printf '%s\n' "$WORKSPACES" | while IFS= read -r sid; do
	[ -z "$sid" ] && continue

	sketchybar --add item space.$sid left \
		--set space.$sid \
		icon="$sid" \
		label.drawing=off \
		icon.padding_left="$CAPSULE_PADDING" \
		icon.padding_right="$CAPSULE_PADDING" \
		background.padding_left=0 \
		background.padding_right=0 \
		script="$PLUGIN_DIR/space.sh" \
		click_script="aerospace workspace $sid" \
		--subscribe space.$sid aerospace_workspace_change mouse.entered mouse.exited mouse.exited.global
done

sketchybar --add item spacer.2 left \
	--set spacer.2 background.drawing=off \
	label.drawing=off \
	icon.drawing=off \
	width="$WIDGET_SPACING"

sketchybar --add bracket spaces '/space.*/' \
	--set spaces background.border_width="$BORDER_WIDTH" \
	background.border_color="$WIDGET_BORDER_COLOR" \
	background.corner_radius="$CORNER_RADIUS" \
	background.color="$BAR_COLOR" \
	background.height="$CAPSULE_HEIGHT" \
	background.drawing=on

sketchybar --add item separator left \
	--set separator icon= \
	icon.font="$FONT:Regular:16.0" \
	background.padding_left="$CAPSULE_PADDING" \
	background.padding_right="$CAPSULE_PADDING" \
	label.drawing=off \
	associated_display=active \
	icon.color="$YELLOW"
