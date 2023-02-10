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
  INSTALL_MODULES=FeatureMain,FeatureJavaHome,FeatureJarFileRunWith
}

# there are specific targets for every major version, let's confugure default values for them
function configureRHSpecificSettings() {
  if [[ $OTOOL_JDK_VERSION -eq 17 ]]; then
    export INSTALL_MODULES="jdk,jdk_registry_runtime,jdk_env_path"
    elif [[ $OTOOL_JDK_VERSION -eq 11 ]]; then
    export INSTALL_MODULES="jdk,jdk_registry_standard,jdk_env_path"
  else
    export INSTALL_MODULES="jdk,jdk_devel,jdk_registry_standard,jdk_registry_standard_devel,jdk_env_path"
  fi
}