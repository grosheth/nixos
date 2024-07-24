#!/usr/bin/env bash
set -E
set -e
set -u
set -o pipefail

readonly PROGNAME=$(basename "$0")
readonly ARGS=("$@")

readonly FONT="JetBrains Nerd Font Mono  14"
readonly POSITION=0
readonly WIDTH=0
readonly XOFF=0
readonly YOFF=0

declare CONNECTION_LIST=""
declare CONNECTION_STATE=false
declare MENU_TITLE=""
declare PICKED_ENTRY=""

usage() {
	cat <<-EOF
		usage: $PROGNAME

		    Creates a rofi menu for projects in ~/work/.

		         -h      show this help

	EOF
	return 0
}

parse_args() {
	while getopts "h" argument; do
		case "$argument" in
		h)
			usage
			exit 0
			;;
		*)
			usage
			exit 1
			;;
		esac
	done
	shift "$((OPTIND - 1))"
	return 0
}

determine_project_list() {
	while IFS='' read -r line; do PROJECT_LIST+=("$line"); done < <(ls -rt ~/work)

	return 0
}

generate_rofi_menu() {
	local length=${#PROJECT_LIST[@]}
	local layout=(-location "${POSITION}" -width "${WIDTH}" -xoffset "${XOFF}" -yoffset "${YOFF}" -lines "${length}")

	PICKED_ENTRY=$(echo -e "${PROJECT_LIST[@]}" | rofi -dmenu -p "PROJECT" "${layout[@]}" -font "${FONT}")

	return 0
}

open_project() {
	if [ -f ~/work/"${PICKED_ENTRY}"/dev.sh ]; then
		bash ~/work/"${PICKED_ENTRY}"/dev.sh
	else
		nvim ~/work/"${PICKED_ENTRY}"
	fi
	return 0
}

main() {
	if [[ "${#ARGS[@]}" -gt 0 ]]; then
		parse_args "${ARGS[@]}"
	fi

	determine_project_list
	generate_rofi_menu
	open_project

	exit 0
}

main
