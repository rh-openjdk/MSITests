#!/bin/bash

## resolve folder of this script, following all symlinks,
## http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
readonly SCRIPT_DIR

set -ex
set -o pipefail

# shellcheck disable=SC1091
source "$SCRIPT_DIR/testlib.bash"

parseArguments "$@"
processArguments

if [ "$MSI_VENDOR" == "Adoptium" ]; then
    echo "$NOT_IMPLEMENTED_ON_ADOPTIUM"
    exit 0   
fi

if [[ $OTOOL_JDK_VERSION -eq 8 ]]; then
  if ! fileExists "${JAVA_INSTALL_DIR}\\webstart\\javaws.exe"; then
    exit 1
  fi
elif [[ $OTOOL_JDK_VERSION -eq 11 ]]; then
  echo $NOT_VALID_ON_OJDK_11
elif [[ $OTOOL_JDK_VERSION -eq 17 ]]; then
  echo $NOT_IMPLEMENTED
fi