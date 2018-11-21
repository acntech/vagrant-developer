#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../.common"

MODULE_NAME="maven"
MODULE_VERSION="3.6.0"
MODULE_INSTALL_DIR="apache-maven-${MODULE_VERSION}"
MODULE_ARCHIVE="${MODULE_NAME}.tar.gz"
MODULE_ARCHIVE_DOWNLOAD_URL="https://www.apache.org/dist/maven/maven-3/${MODULE_VERSION}/binaries/apache-maven-${MODULE_VERSION}-bin.tar.gz"

# Download module
download_module_archive "${MODULE_ARCHIVE}" "${MODULE_ARCHIVE_DOWNLOAD_URL}"

# Install module
install_archive_module "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"

# Update alternatives for executables
install_module_executable "${MODULE_NAME}" "mvn"

# Set module profile
install_module_profile "${MODULE_NAME}" "MAVEN_HOME" "M2_HOME"
