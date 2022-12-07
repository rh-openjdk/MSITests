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

installOpenJDK 2>&1| tee "$REPORT_FILE"

# TODORC: handle error codes here
# This installation package could not be opened. 
# http://hydra.brq.redhat.com:8080/job/tps~win~msi-jp8-ojdk8~winmsis~signed-win2012.x86_64-release.sdk-win10.x86_64.vagrant-x11.defaultgc.legacy.lnxagent.jfroff/66/consoleFull