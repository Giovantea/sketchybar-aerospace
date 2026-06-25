#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$HOME/.config/sketchybar/helpers/ui.sh"
	apply_hover_animation "$SENDER" "$NAME"
	exit 0
	;;
esac

sketchybar --set "$NAME" icon="" label="$(ps -A -o %cpu | awk '{s+=$1} END {s /= 8} END {printf "%.1f%%\n", s}')"
