#!/bin/bash
# shellcheck disable=SC1090,SC1091

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

# propagate RESULTS_FOLDER_NAME_INPUT for the custom path for storing tests results here
# otherwise results forlder will be used
export RESULTS_FOLDER_NAME="${RESULTS_FOLDER_NAME_INPUT:-results}" 

# propagate JDK_VERSION_INPUT for definition which subset of tests should run
# otherwise version 11 will be used
export OTOOL_JDK_VERSION="${JDK_VERSION_INPUT:-11}" #todorc: implement detection of java version

# propagate MSI_VENDOR_INPUT variable
# this will ensure vendor specific parts of tests will be applied
# otherwise RH will be used
# Possible implemented values are Adoptium and RH
# You can configure specifics in configure-vendor-specific-settings.sh
export MSI_VENDOR="${MSI_VENDOR_INPUT:-RH}"

# propagate INPUT_PATH_INPUT to folder containing one msi used for tests
# otherwise ../input forlder will be used
export INPUT_FOLDER=$SCRIPT_DIR"${INPUT_PATH_INPUT:-/../input}"

# propagate CURRENT_USER_INPUT
# this should contains user used for testing
# by default tester is used
export CURRENT_USER_NAME="${CURRENT_USER_NAME_INPUT:-tester}"

# propagate INSTALL_LOCATION_INPUT for the place where java will be installed
export INSTALL_DIR_INPUT=C:\\\\Users\\\\$CURRENT_USER_NAME\\\\java

# dependencies
export OTOOL_jresdk=sdk #hardcoded value, just sdk tests are implemented, not jre which it the other possibility

source "$SCRIPT_DIR"/configure-vendor-specific-settings.sh
setupVendorSpecific

export INSTALL_LOG_FOLDER_INPUT=C:\\\\Users\\\\$CURRENT_USER_NAME\\\\install_log

bash "$SCRIPT_DIR"/run-folder-as-tests.sh "$SCRIPT_DIR"/../tps 