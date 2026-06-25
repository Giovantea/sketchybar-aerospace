#!/usr/bin/env bash

aerospace_all_workspaces() {
	aerospace list-workspaces --all 2>/dev/null | awk '/^[0-9]+$/ { print }' | sort -n
}

aerospace_focused_workspace() {
	aerospace_focused_workspace_value="$1"
	aerospace_cache_dir="${TMPDIR:-/tmp}"
	[ -d "$aerospace_cache_dir" ] || aerospace_cache_dir="/tmp"
	aerospace_cache_file="${aerospace_cache_dir%/}/sketchybar_focused_workspace"

	if [ "$aerospace_focused_workspace_value" != "" ]; then
		printf '%s\n' "$aerospace_focused_workspace_value" >"$aerospace_cache_file" 2>/dev/null
	elif [ -f "$aerospace_cache_file" ]; then
		aerospace_now="$(date +%s)"
		aerospace_cache_mtime="$(stat -f %m "$aerospace_cache_file" 2>/dev/null || echo 0)"

		if [ "$aerospace_cache_mtime" != "" ] && [ $((aerospace_now - aerospace_cache_mtime)) -le 1 ]; then
			aerospace_focused_workspace_value="$(cat "$aerospace_cache_file")"
		fi
	fi

	if [ "$aerospace_focused_workspace_value" = "" ]; then
		aerospace_focused_workspace_value="$(aerospace list-workspaces --focused 2>/dev/null)"
		[ "$aerospace_focused_workspace_value" != "" ] && printf '%s\n' "$aerospace_focused_workspace_value" >"$aerospace_cache_file" 2>/dev/null
	fi

	printf '%s\n' "$aerospace_focused_workspace_value"
}
