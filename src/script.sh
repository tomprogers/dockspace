#!/usr/bin/env bash

set -o errexit # exit on error
set -o errtrace # exit on error inside functions / subshells
set -o nounset # exit when accessing undefined vars
set -o pipefail # catch errors thrown in commands piped to this one
# set -o xtrace # for debugging only

DEFAULT_ICON_COLOR='"#000000"' # used for any workspace without settings['peacock.color']

function dockify() {
	local sourceDir="${1}"
	local iconSvgPath="${2}"
	local outputDir="${3}"

	echo "reading files from ${sourceDir}"
	echo "using icon ${iconSvgPath}"
	echo "writing files to ${outputDir}"

	local vscw="" # path to workspace file
	local color="" # peacock color in workspace file
	for vscw in $(find "${sourceDir}" -iname "*.code-workspace")
	do
		echo "examining ${vscw}..."

		# step 1: obtain peacock color
		color="$(jq '.settings | ."peacock.color"' ${vscw})"
		if [[ "${color}" = "null" ]]; then
			color="${DEFAULT_ICON_COLOR}"
		fi

		echo "> color=${color}"

		# step 2: generate
		echo "temp: ${TMPDIR}"
	done
}




# let people load this tool by sourcing it or including it in PATH
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f dockify
else
  dockify "${@}"
  exit ${?}
fi
