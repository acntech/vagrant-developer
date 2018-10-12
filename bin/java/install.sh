#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../.common"

MODULE_NAME="java"
MODULE_INSTALL_DIR="jdk1.8.0_181"
MODULE_ARCHIVE="${MODULE_NAME}.tar.gz"
MODULE_ARCHIVE_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz"

# Download module
download_module_archive "${MODULE_ARCHIVE}" "${MODULE_ARCHIVE_DOWNLOAD_URL}" "Cookie: oraclelicense=accept-securebackup-cookie"

# Install module
install_external_module "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"

# Update alternatives for executables
install_module_executable "java" "java"
install_module_executable "java" "javac"
install_module_executable "java" "jar"

# Set module profile
install_module_profile "${MODULE_NAME}" "JAVA_HOME"

# Set RNG to urandom to make random number generation faster
sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/g' /opt/java/default/jre/lib/security/java.security
