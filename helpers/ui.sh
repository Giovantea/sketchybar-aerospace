#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

apply_hover_animation() {
	case "$1" in
	"mouse.entered")
		sketchybar --animate tanh "$HOVER_ANIMATION_DURATION" --set "$2" background.color="$HOVER_BACKGROUND_COLOR"
		return 0
		;;
	"mouse.exited")
		sketchybar --animate tanh "$HOVER_ANIMATION_DURATION" --set "$2" background.color="$BAR_COLOR"
		return 0
		;;
	esac

	return 1
}
