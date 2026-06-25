#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$HOME/.config/sketchybar/helpers/ui.sh"
	apply_hover_animation "$SENDER" "$NAME"
	exit 0
	;;
esac

[ "$INFO" = "" ] && sketchybar --set "$NAME" drawing=off && exit 0

MEDIA="$(printf '%s' "$INFO" | jq -r 'if .state == "playing" and .app == "Spotify" then ((.title // "") + " - " + (.artist // "")) else empty end')"

if [ "$MEDIA" != "" ]; then
	sketchybar --set "$NAME" label="$MEDIA" drawing=on
else
	sketchybar --set "$NAME" drawing=off
fi
