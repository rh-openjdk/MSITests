#!/bin/bash
# shellcheck disable=SC2143

function setupVendorSpecific() {
  if [ "${MSI_VENDOR:?}" == "Adoptium" ]; then
    configureAdoptiumSpecificSettings
  else
    configureRHSpecificSettings
  fi
}

function configureAdoptiumSpecificSettings() {
  # check if this is the default configuration
  export INSTALL_MODULES=FeatureMain,FeatureJavaHome,FeatureJarFileRunWith

  # todorc: configure Adoptium registry values
}

# there are specific targets for every major version, let's configure default values for them
function configureRHSpecificSettings() {
  if [[ $OTOOL_JDK_VERSION -eq 21 ]]; then
    export INSTALL_MODULES="jdk,jdk_registry_runtime,jdk_env_path"
  fi

case $OTOOL_JDK_VERSION in
  8)
    export INSTALL_MODULES="jdk,jdk_devel,jdk_registry_standard,jdk_registry_standard_devel,jdk_env_path"
    ;;
  11)
    export INSTALL_MODULES="jdk,jdk_registry_standard,jdk_env_path"
    ;;
  17)
    export INSTALL_MODULES="jdk,jdk_registry_runtime,jdk_env_path"
    ;;
  21)
      export INSTALL_MODULES="jdk,jdk_registry_runtime,jdk_env_path"
      ;;
  *)
    echo "Unsupported JDK version."
    ;;
esac

  if [[ $(ls "$INPUT_FOLDER" | grep "java-1.8.0-openjdk") ]]; then
    export JDK_REG="HKLM\Software\JavaSoft\Java Development Kit"
    export JAVA_JDK_JVM_DLL=${JAVA_INSTALL_DIR_REG}\\\\jre\\\\bin\\\\server\\\\jvm.dll
    export JAVA_INSTALL_JRE_DIR_REG=$INSTALL_DIR_INPUT\\\\jre
  elif [[ $(ls "$INPUT_FOLDER" | grep "java-11-openjdk") ]]; then
    export JDK_REG_VERSION=$(ls | grep -oP 11.[0-9].[0-9][0-9])
    export JDK_REG="HKLM\Software\JavaSoft\JDK\\${JDK_REG_VERSION}"
    export JAVA_JDK_JVM_DLL=${JAVA_INSTALL_DIR_REG}\\\\bin\\\\server\\\\jvm.dll
  elif [[ $(ls "$INPUT_FOLDER" | grep "java-17-openjdk") ]]; then
    export JDK_REG_VERSION=17
    export JDK_REG="HKLM\Software\JavaSoft\JDK\\${JDK_REG_VERSION}"
    export JAVA_JDK_JVM_DLL=${JAVA_INSTALL_DIR_REG}\\\\bin\\\\server\\\\jvm.dll
  elif [[ $(ls "$INPUT_FOLDER" | grep "java-21-openjdk") ]]; then
    export JDK_REG_VERSION=21
    export JDK_REG="HKLM\Software\JavaSoft\JDK\\${JDK_REG_VERSION}"
    export JAVA_JDK_JVM_DLL=${JAVA_INSTALL_DIR_REG}\\\\bin\\\\server\\\\jvm.dll
  else
    ls
    echo "don't know the java version"
    exit 1
  fi
}
