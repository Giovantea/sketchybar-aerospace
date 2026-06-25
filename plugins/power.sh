#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered" | "mouse.exited")
	source "$HOME/.config/sketchybar/helpers/ui.sh"
	apply_hover_animation "$SENDER" "$NAME"
	exit 0
	;;
esac

read -r PERCENTAGE CHARGING <<EOF
$(pmset -g batt | awk '
/Now drawing from/ && /AC Power/ { charging = 1 }
/%/ {
	for (i = 1; i <= NF; i++) {
		if ($i ~ /%/) {
			gsub(/[^0-9]/, "", $i)
			percentage = $i
		}
	}
}
END { print percentage, charging }
')
EOF

if [ "$PERCENTAGE" = "" ]; then
	exit 0
fi

case ${PERCENTAGE} in
9[0-9] | 100)
	ICON=""
	;;
[6-8][0-9])
	ICON=""
	;;
[3-5][0-9])
	ICON=""
	;;
[1-2][0-9])
	ICON=""
	;;
*) ICON="" ;;
esac

if [ "$CHARGING" != "" ]; then
	ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}% "
