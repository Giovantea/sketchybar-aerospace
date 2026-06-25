#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$HOME/.config/sketchybar/helpers/ui.sh"
	apply_hover_animation "$SENDER" "$NAME"
	exit 0
	;;
esac

app_name="$INFO"

if [ -z "$app_name" ] && command -v aerospace >/dev/null 2>&1; then
	app_name="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
fi

[ -z "$app_name" ] && exit 0

sketchybar --set "$NAME" label="$app_name"
