#!/bin/bash

JAVA_INSTALL_DIR=R:\\java
JAVA_EXE=${JAVA_INSTALL_DIR}\\bin\\java.exe
JAVA_INSTALL_DIR_REG=R:\\\\java
SYS_ENV_REG="HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
RPMS_DIR=/mnt/workspace/rpms

export NOT_IMPLEMENTED="!skipped!, because not implemented yet"
export NOT_VALID_ON_OJDK_11="!skipped!, because not valid on ojkd 11"

function isMSI() {
  return 0
}

function detectJdkAndSetVars() {
  pushd ${RPMS_DIR}
  if [[ $(ls | grep "java-1.8.0-openjdk") ]]; then
    export JDK_REG="HKLM\Software\JavaSoft\Java Development Kit"
    export JAVA_JDK_JVM_DLL=${JAVA_INSTALL_DIR_REG}\\\\jre\\\\bin\\\\server\\\\jvm.dll
    export JAVA_INSTALL_JRE_DIR_REG=R:\\\\java\\\\jre
  elif [[ $(ls | grep "java-11-openjdk") ]]; then
    export JDK_REG_VERSION=$(ls | grep -oP "11\.\d{1,2}\.\d{1,2}")
    export JDK_REG="HKLM\Software\JavaSoft\JDK\\${JDK_REG_VERSION}"
    export JAVA_JDK_JVM_DLL=${JAVA_INSTALL_DIR_REG}\\\\bin\\\\server\\\\jvm.dll
  else
    ls
    echo "don't know the java version"
    exit 1
  fi
  popd
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
