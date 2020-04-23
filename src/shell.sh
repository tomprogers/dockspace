#!/usr/bin/env bash

set -o errexit # exit on error
set -o errtrace # exit on error inside functions / subshells
set -o nounset # exit when accessing undefined vars
set -o pipefail # catch errors thrown in commands piped to this one
# set -o xtrace # for debugging only

DEFAULT_ICON_COLOR="#000000" # used for any workspace without settings['peacock.color']

function dockify() {
  local sourceDir="${1}"
  local iconSvgPath="${2}"
  local outputDir="${3}"

  echo "reading files from ${sourceDir}"
  echo "using icon ${iconSvgPath}"
  echo "writing files to ${outputDir}"
  echo "temporary directory is ${TMPDIR}"

  local vscw="" # path to workspace file
  for vscw in $(find "${sourceDir}" -iname "*.code-workspace")
  do
    echo "examining ${vscw}..."
    local projectName="$(basename "${vscw}" .code-workspace)" # will hold the basename of each workspace file (without extension)


    # step 1: obtain peacock color
    local color="$(jq -r '.settings | ."peacock.color"' ${vscw})" # will be value of peacock.color (or default, above) WITH surrounding quotes
    if [[ "${color}" = "null" ]]; then
      color="${DEFAULT_ICON_COLOR}"
    fi

    echo "> color=${color}"

    # step 2: generate custom SVG from template, inserting with correct color
    local newSvg="" # will hold newly-written SVG code
    while IFS="<$IFS" read tag
    do
      if [[ "${tag}" =~ \ *id\ *=\ *\"peacock\.color\" ]]; then
        tag=$(echo "${tag}" | sed -E 's/fill:[^;]+;/fill:'"${color}"';/')
      fi
      newSvg="${newSvg}${tag}"
    done < ${iconSvgPath}

    # write new SVG to temp file
    local mySvgPath="${TMPDIR}${projectName}.svg"
    echo "${newSvg}" > "${mySvgPath}"

    # step 3: use the svg as the icon for the code-workspace file

    # convert svg to png
    local myPngPath="${TMPDIR}${projectName}.png"
    rsvg-convert -w 512 ${mySvgPath} > ${myPngPath}

    # make the image its own icon
    sips -i ${myPngPath}

    # extract icon as resource file
    local myRsrcPath="${TMPDIR}${projectName}.rsrc"
    DeRez -only icns ${myPngPath} > ${myRsrcPath}

    # append new resource to the workspace file
    Rez -append ${myRsrcPath} -o ${vscw}

    # set icon
    SetFile -a C ${vscw}

    # step 4: create symlink to workspace file in output directory
    local projectNameLowercase="$(echo "${projectName}" | tr '[:upper:]' '[:lower:]')"
    local mySymlinkPath="${outputDir}/${projectNameLowercase}"
    ln -sfn ${vscw} ${mySymlinkPath}


    # step 5: cleanup

    # delete temp files
    rm "${mySvgPath}"
    rm "${myPngPath}"
    rm "${myRsrcPath}"
  done
}




# let people load this tool by sourcing it or including it in PATH
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f dockify
else
  dockify "${@}"
  exit ${?}
fi
