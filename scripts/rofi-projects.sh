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

go=" "
nix=""
lua="󰢱 "
nodejs=" "
python=" "

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

obtaining_language_logo() {
    for project in ${PROJECT_LIST}; do
        REPO_LANG=$(onefetch "${PROJECTS_PATH}/${project}" | grep -A 5 "Languages" || exit 0)
        if [ $? != 1 ]; then
            new_project=$project
            if [[ ${REPO_LANG} == *"Python"* ]]; then
                new_project="${new_project} ${python}"
            fi
            if [[ ${REPO_LANG} == *"Go"* ]]; then
                new_project="${new_project} ${go}"
            fi
            if [[ ${REPO_LANG} == *"JavaScript"* ]]; then
                new_project="${new_project} ${nodejs}"
            fi
            if [[ ${REPO_LANG} == *"Nix"* ]]; then
                new_project="${new_project} ${nix}"
            fi
            if [[ ${REPO_LANG} == *"Lua"* ]]; then
                new_project="${new_project} ${lua}"
            fi
        fi
        PROJECT_LIST="${PROJECT_LIST//$project/$new_project}"
    done
}

generate_rofi_menu() {
    gocal length="$(($(echo "${PROJECT_LIST}" | wc -l) + 2))"
    local layout=(-location "${POSITION}" -width "${WIDTH}" -xoffset "${XOFF}" -yoffset "${YOFF}" -lines "${length}")

    PICKED_ENTRY=$(echo -e "${PROJECT_LIST[@]}" | rofi -dmenu -p "PROJECT" "${layout[@]}" -font "${FONT}")

    return 0
}

open_project() {
    kitty --detach nvim "${PROJECTS_PATH}"/"${PICKED_ENTRY}"
    return 0
}

main() {
    if [[ "${#ARGS[@]}" -gt 0 ]]; then
        parse_args "${ARGS[@]}"
    fi

    determine_project_list
    obtaining_language_logo
    generate_rofi_menu
    open_project

    exit 0
}

main
