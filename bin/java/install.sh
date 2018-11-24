#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../common.sh"
source "${SCRIPT_DIR}/version.sh"

MODULE_NAME="java"
MODULE_INSTALL_DIR="jdk${MODULE_VERSION}"
MODULE_ARCHIVE="${MODULE_NAME}.tar.gz"

if module_install_dir_exist "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"; then
    log " "
    log " Module ${MODULE_NAME} is already installed"
    exit 0
fi

# Download module
download_module_archive "${MODULE_ARCHIVE}" "${MODULE_ARCHIVE_DOWNLOAD_URL}" "Cookie: oraclelicense=accept-securebackup-cookie"

# Install module
install_archive_module "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"

# Update alternatives for executables
install_module_executable "java" "java"
install_module_executable "java" "javac"
install_module_executable "java" "jar"

# Set module profile
install_module_profile "${MODULE_NAME}" "JAVA_HOME"

# Set RNG to urandom to make random number generation faster
log " "
log " Setting Java RNG to /dev/urandom"
sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/g' /opt/java/default/jre/lib/security/java.security
