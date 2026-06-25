#!/usr/bin/env bash

COLOR="$YELLOW"

sketchybar --add item cpu right \
	--set cpu \
	update_freq=5 \
	icon.color="$COLOR" \
	icon.padding_left="$CAPSULE_PADDING" \
	icon.padding_right="$PADDINGS" \
	label.color="$COLOR" \
	label.padding_left="$PADDINGS" \
	label.padding_right="$CAPSULE_PADDING" \
	background.height="$CAPSULE_HEIGHT" \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_left="$WIDGET_SPACING" \
	background.padding_right="$WIDGET_SPACING" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$WIDGET_BORDER_COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/cpu.sh" \
	--subscribe cpu mouse.entered mouse.exited
