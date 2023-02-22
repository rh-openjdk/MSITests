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
set -o pipefail

# shellcheck disable=SC1091
source "$SCRIPT_DIR/testlib.bash"

parseArguments "$@"
processArguments

if [ "$MSI_VENDOR" == "Adoptium" ]; then
    echo "$NOT_IMPLEMENTED_ON_ADOPTIUM"
    exit 0   
fi

set +e

FAILED_TESTS=0

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.jar" 2>&1
let FAILED_TESTS=$FAILED_TESTS+$?

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\JARFile\Shell\Open\Command" 2>&1
let FAILED_TESTS=$FAILED_TESTS+$?

if [[ $FAILED_TESTS -ne 2 ]]; then
        echo "There are JAR association records in the registry."
        exit 1
fi
