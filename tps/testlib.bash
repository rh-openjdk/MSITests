#!/bin/bash

## resolve folder of this script, following all symlinks,
## http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TPS_SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
readonly TPS_SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

set -ex
set -o pipefail

JAVA_INSTALL_DIR=$INSTALL_DIR_INPUT
INSTALL_MODULES=

if [[ $OTOOL_JDK_VERSION -eq 17 ]]; then
  INSTALL_MODULES="jdk,jdk_registry_runtime,jdk_env_path"
elif [[ $OTOOL_JDK_VERSION -eq 11 ]]; then
  INSTALL_MODULES="jdk,jdk_registry_standard,jdk_env_path"
else
  INSTALL_MODULES="jdk,jdk_devel,jdk_registry_standard,jdk_registry_standard_devel,jdk_env_path"
fi

LOG_DIR_WIN=$INSTALL_LOG_FOLDER_INPUT

# shellcheck disable=SC1091
source "$TPS_SCRIPT_DIR/common.bash"

if [[ $OTOOL_OS_VERSION -eq 2012 ]]; then
  mkdir -p /cygdrive/c/Users/tester/java
  mkdir -p /cygdrive/c/Users/tester/tps
  JAVA_INSTALL_DIR="C:\Users\tester\java"
  LOG_DIR_WIN="C:\Users\tester\tps"
fi

parseArguments() {
  for a in "$@"; do
    case $a in
    --jdk=*)
      ARG_JDK="${a#*=}" # preventing unrecognized argument error, intentional ignore here
      ;;
    --report-dir=*)
      ARG_REPORT_DIR="${a#*=}"
      ;;
    *)
      echo "Unrecognized argument: '$a'" >&2
      exit 1
      ;;
    esac
  done
}

processArguments() {
  if [[ -z $ARG_REPORT_DIR ]]; then
    echo "Report dir was not specified" >&2
    exit 1
  else
    readonly REPORT_DIR="$(readlink -m "$ARG_REPORT_DIR")"
    mkdir -p "$REPORT_DIR"
  fi

  readonly REPORT_FILE="$REPORT_DIR/report.txt"
}

function thereIsNoJava() {
  if type -p java; then
    echo found java executable in PATH
    _java=java
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    echo found java executable in JAVA_HOME
    _java="$JAVA_HOME/bin/java"
  else
    echo "no java detected"
  fi

  if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "java detected!"
    echo version "$version"
    return 1
  fi
}

function installOpenJDK() {
  if [ "${OTOOL_jresdk:?}" == "sdk" ]; then
    installSDK
  fi
  if [ "$OTOOL_jresdk" == "jre" ]; then
    INSTALL_MODULES="jdk"
    echo "$NOT_IMPLEMENTED"
  fi
}

function installSDK() {
  if isMSI; then
    installMSI
  fi
}

function installMSI() {
  pushd "$RPMS_DIR"
  rm -rf $JAVA_INSTALL_DIR
  INSTALL_LOG_PATH=${LOG_DIR_WIN}\\javainstall-$(date +%s%N).log
  msiexec /i *.msi INSTALLDIR=${JAVA_INSTALL_DIR} ADDLOCAL=${INSTALL_MODULES} /quiet /Lv* "$INSTALL_LOG_PATH" || true
  cp "$INSTALL_LOG_PATH" $RESULTS_FOLDER
  popd
}

function uninstallMSI() {
  pushd "$RPMS_DIR"
  UNINSTALL_LOG_PATH=${LOG_DIR_WIN}\\javauninstall-$(date +%s%N).log
  msiexec /x *.msi INSTALLDIR=${JAVA_INSTALL_DIR} /quiet /Lv* "$UNINSTALL_LOG_PATH" || true
  cp "$UNINSTALL_LOG_PATH" $RESULTS_FOLDER
  popd
}
