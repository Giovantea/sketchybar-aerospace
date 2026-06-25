#!/usr/bin/env bash

COLOR="$GREEN"

sketchybar --add item spotify q \
	--set spotify \
	scroll_texts=on \
	icon=󰎆 \
	icon.color="$COLOR" \
	icon.padding_left="$CAPSULE_PADDING" \
	icon.padding_right="$PADDINGS" \
	background.color="$BAR_COLOR" \
	background.height="$CAPSULE_HEIGHT" \
	background.corner_radius="$CORNER_RADIUS" \
	background.border_width="$BORDER_WIDTH" \
	background.border_color="$WIDGET_BORDER_COLOR" \
	background.padding_left="$WIDGET_SPACING" \
	background.padding_right="$WIDGET_SPACING" \
	background.drawing=on \
	label.padding_left="$PADDINGS" \
	label.padding_right="$CAPSULE_PADDING" \
	label.max_chars=23 \
	associated_display=active \
	updates=on \
	script="$PLUGIN_DIR/spotify.sh" \
	--subscribe spotify media_change mouse.entered mouse.exited
