#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$HOME/.config/sketchybar/helpers/ui.sh"
	apply_hover_animation "$SENDER" "$NAME"
	exit 0
	;;
esac

LABEL=$(date '+%H:%M:%S')
sketchybar --set "$NAME" label="$LABEL"
