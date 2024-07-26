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
readonly PROJECTS_PATH="${HOME}/work"

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
	PROJECT_LIST=$(ls -rt "${PROJECTS_PATH}")

	return 0
}

# obtaining_language_logo() {
# 	echo "TODO"
# 	REPO_LANG=$()
# }

generate_rofi_menu() {
	local length="$(($(echo "${PROJECT_LIST}" | wc -l) + 2))"
	local layout=(-location "${POSITION}" -width "${WIDTH}" -xoffset "${XOFF}" -yoffset "${YOFF}" -lines "${length}")

	PICKED_ENTRY=$(echo -e "${PROJECT_LIST[@]}" | rofi -dmenu -p "PROJECT" "${layout[@]}" -font "${FONT}")

	return 0
}

open_project() {
	# command="[ -f ${PROJECTS_PATH}/${PICKED_ENTRY}/dev.sh ] && bash ${PROJECTS_PATH}/${PICKED_ENTRY}/dev.sh || nvim ${PROJECTS_PATH}/${PICKED_ENTRY}"
	command="nvim ${PROJECTS_PATH}/${PICKED_ENTRY}"
	kitty --detach "${command}"
	return 0
}

main() {
	if [[ "${#ARGS[@]}" -gt 0 ]]; then
		parse_args "${ARGS[@]}"
	fi

	determine_project_list
	# obtaining_language_logo
	generate_rofi_menu
	open_project

	exit 0
}

main
