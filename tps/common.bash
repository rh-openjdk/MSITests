#!/bin/bash

JAVA_INSTALL_DIR=$INSTALL_DIR_INPUT
JAVA_EXE=${JAVA_INSTALL_DIR}\\bin\\java.exe
JAVA_INSTALL_DIR_REG=$INSTALL_DIR_INPUT
SYS_ENV_REG="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
RPMS_DIR=$INPUT_FOLDER

if [[ $OTOOL_OS_VERSION -eq 2012 ]]; then
  JAVA_INSTALL_DIR="C:\Users\$CURRENT_USER_NAME\java"
  JAVA_INSTALL_DIR_REG="C:\\\\Users\\\\$CURRENT_USER_NAME\\\\java"  
fi

export NOT_IMPLEMENTED="!skipped!, because not implemented yet"
export NOT_VALID_ON_OJDK_8="!skipped!, because not valid on ojkd 8"
export NOT_VALID_ON_OJDK_11="!skipped!, because not valid on ojkd 11"
export NOT_VALID_ON_OJDK17="!skipped!, because not valid on ojkd 17"

function isMSI() {
  return 0
}

function fileExists() {
  if [ ! -f "$1" ]; then
    echo "$1 file is missing"
    return 1
  fi
}

function directoryExists() {
  if [ ! -d "$1" ]; then
    echo "$1 directory is missing"
    return 1
  fi
}

function isVariableSet {
  if [ -z ${1+x} ]; then
    echo "'$1' is unset"
    return 1
  else
    echo "var is set to '$1'"
  fi
}
