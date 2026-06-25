#!/usr/bin/env bash

COLOR="$CYAN"

sketchybar --add item battery right \
	--set battery \
	update_freq=120 \
	icon.color="$COLOR" \
	icon.padding_left="$CAPSULE_PADDING" \
	icon.padding_right="$PADDINGS" \
	label.padding_left="$PADDINGS" \
	label.padding_right="$CAPSULE_PADDING" \
	label.color="$COLOR" \
	background.height="$CAPSULE_HEIGHT" \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_left="$WIDGET_SPACING" \
	background.padding_right="$WIDGET_SPACING" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$WIDGET_BORDER_COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/power.sh" \
	--subscribe battery power_source_change mouse.entered mouse.exited
