#!/usr/bin/env bash

COLOR="$WHITE"

sketchybar \
	--add item front_app left \
	--set front_app script="$PLUGIN_DIR/front_app.sh" \
	icon.drawing=off \
	background.height="$CAPSULE_HEIGHT" \
	background.padding_left="$WIDGET_SPACING" \
	background.padding_right="$WIDGET_SPACING" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$WIDGET_BORDER_COLOR" \
	background.corner_radius="$CORNER_RADIUS" \
	background.color="$BAR_COLOR" \
	label.color="$COLOR" \
	label.padding_left="$CAPSULE_PADDING" \
	label.padding_right="$CAPSULE_PADDING" \
	associated_display=active \
	--subscribe front_app front_app_switched mouse.entered mouse.exited
