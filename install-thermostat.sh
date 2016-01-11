#!/bin/bash
if [ $# -ne 1 ]; then
  echo "usage: bash $0 path/to/thermostat-home/dir" 1>&2
  exit 1
fi
THERMOSTAT_HOME=$1
BM_FOLDER=${THERMOSTAT_HOME}/libs/byteman
BM_HOME_INSTALL=${BM_FOLDER}/byteman-install
BM_HELPER_INSTALL=${BM_FOLDER}/thermostat-helper
BM_PLUGIN_HOME=${THERMOSTAT_HOME}/plugins/vm-byteman
if [ ! -e ${THERMOSTAT_HOME} ]; then
  echo "THERMOSTAT_HOME=${THERMOSTAT_HOME} does not exist. Error." 1>&2
  exit 1
fi
if [ ! -e ${BM_FOLDER} ]; then
  echo "'byteman' subdir in libs folder of THERMOSTAT_HOME=${THERMOSTAT_HOME} does not exist. Error." 1>&2
  exit 1
fi
if [ ! -e ${BM_HELPER_INSTALL} ]; then
  echo "'thermostat-helper' subdir in folder ${BM_FOLDER} does not exist. Error." 1>&2
  exit 1
fi
rm -rf ${BM_HOME_INSTALL}
unzip -d ${BM_HOME_INSTALL} download/target/byteman-download-*-full.zip
mv ${BM_HOME_INSTALL}/byteman-download-*/* ${BM_HOME_INSTALL}
rmdir ${BM_HOME_INSTALL}/byteman-download-*

# Fix up byteman jars with osgi bundles
rm -rf ${BM_HELPER_INSTALL}/byteman*.jar
pushd ${BM_HELPER_INSTALL}
  ln -s ${BM_HOME_INSTALL}/lib/byteman.jar byteman.jar
popd
rm -rf ${BM_PLUGIN_HOME}/byteman*.jar
pushd ${BM_PLUGIN_HOME}
  ln -s ${BM_HOME_INSTALL}/lib/byteman-install.jar byteman-install.jar
  ln -s ${BM_HOME_INSTALL}/lib/byteman-submit.jar byteman-submit.jar
popd
