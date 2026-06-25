#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$HOME/.config/sketchybar/helpers/ui.sh"
	apply_hover_animation "$SENDER" "$NAME"
	exit 0
	;;
esac

VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [ "$MUTED" != "false" ]; then
	ICON="󰖁"
	VOLUME=0
else
	case ${VOLUME} in
	100) ICON="" ;;
	[5-9]*) ICON="" ;;
	[0-9]*) ICON="" ;;
	*) ICON="" ;;
	esac
fi

sketchybar -m \
	--set "$NAME" icon=$ICON \
	--set "$NAME" label="$VOLUME%"
