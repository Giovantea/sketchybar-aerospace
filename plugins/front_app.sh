#!/usr/bin/env bash

app_name="$INFO"

if [ -z "$app_name" ] && command -v aerospace >/dev/null 2>&1; then
	app_name="$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null)"
fi

[ -z "$app_name" ] && exit 0

sketchybar --set "$NAME" label="$app_name"
