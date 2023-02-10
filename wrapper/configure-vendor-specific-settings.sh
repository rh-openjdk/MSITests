#!/bin/bash



# todorc: extract modules
#export INSTALL_MODULES="jdk,jdk_registry_standard,jdk_env_path"

function setupVendorSpecific() {
  if [ "${MSI_VENDOR:?}" == "Adoptium" ]; then
    configureAdoptiumSpecificSettings
  else
    configureRHSpecificSettings
  fi
}

function configureAdoptiumSpecificSettings() {
  echo "Adoptium specific settings applied"
}

function configureRHSpecificSettings() {
  if [[ $OTOOL_JDK_VERSION -eq 17 ]]; then
    INSTALL_MODULES="jdk,jdk_registry_runtime,jdk_env_path"
    elif [[ $OTOOL_JDK_VERSION -eq 11 ]]; then
    INSTALL_MODULES="jdk,jdk_registry_standard,jdk_env_path"
  else
    INSTALL_MODULES="jdk,jdk_devel,jdk_registry_standard,jdk_registry_standard_devel,jdk_env_path"
  fi
}