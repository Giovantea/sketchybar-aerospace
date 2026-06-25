#!/usr/bin/env bash

COLOR="$MAGENTA"

sketchybar --add item clock right \
	--set clock update_freq=1 \
	icon.padding_left="$CAPSULE_PADDING" \
	icon.padding_right="$PADDINGS" \
	icon.color="$COLOR" \
	icon="" \
	label.color="$COLOR" \
	label.padding_left="$PADDINGS" \
	label.padding_right="$CAPSULE_PADDING" \
	label.width=78 \
	align=center \
	background.height="$CAPSULE_HEIGHT" \
	background.corner_radius="$CORNER_RADIUS" \
	background.padding_left="$WIDGET_SPACING" \
	background.padding_right="$WIDGET_SPACING" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$WIDGET_BORDER_COLOR" \
	background.color="$BAR_COLOR" \
	background.drawing=on \
	script="$PLUGIN_DIR/clock.sh" \
	--subscribe clock mouse.entered mouse.exited
