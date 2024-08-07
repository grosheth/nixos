#!/usr/bin/env bash

while IFS='' read -r line; do WORK_REPO+=("$line"); done < <(ls -rt ~/work)

echo -e "Here is a list of the available projects: "
for index in "${!WORK_REPO[@]}"; do
	echo -e "\e[1m${index} \e[4m${WORK_REPO[index]}\e[24m"
done

# Try to do it in rofi
while [[ ! "${project}" =~ ^[0-9]+$ ]]; do
	read -p "Which project do you want to work on: (number)" project
done

if [ -f ~/work/"${WORK_REPO[${project}]}"/dev.sh ]; then
	bash ~/work/"${WORK_REPO[${project}]}"/dev.sh
else
	nvim ~/work/"${WORK_REPO[${project}]}"
fi
