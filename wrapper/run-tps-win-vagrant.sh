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

set -x
set -e
set -o pipefail

export RESULTS_FOLDER_NAME="${RESULTS_FOLDER_NAME_INPUT:-results}" 

# dependencies
export OTOOL_jresdk=sdk
export INPUT_FOLDER=$SCRIPT_DIR/../input
export CURRENT_USER_NAME=tester
export INSTALL_DIR_INPUT=C:\\\\Users\\\\$CURRENT_USER_NAME\\\\java
export OTOOL_JDK_VERSION=11 #todorc: implement detection of java version

# todorc: extract modules
#export INSTALL_MODULES="jdk,jdk_registry_standard,jdk_env_path"

export INSTALL_LOG_FOLDER_INPUT=C:\\\\Users\\\\$CURRENT_USER_NAME\\\\install_log

bash "$SCRIPT_DIR"/run-folder-as-tests.sh "$SCRIPT_DIR"/../tps 