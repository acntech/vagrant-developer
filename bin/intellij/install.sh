#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../.common"

MODULE_NAME="intellij"
MODULE_VERSION="2018.2.6"
MODULE_EDITION="ideaIC"
MODULE_DESCRIPTION="IntelliJ IDEA Community"
MODULE_INSTALL_DIR="${MODULE_EDITION}-${MODULE_VERSION}"
MODULE_ARCHIVE="${MODULE_NAME}.tar.gz"
MODULE_ARCHIVE_DOWNLOAD_URL="https://download.jetbrains.com/idea/${MODULE_EDITION}-${MODULE_VERSION}-no-jdk.tar.gz"
MODULE_EXECUTABLE="/opt/${MODULE_NAME}/default/bin/idea.sh"
MODULE_ICON="/opt/${MODULE_NAME}/default/bin/idea.png"
MODULE_CATEGORIES="Development;Application;"

# Download module
download_module_archive "${MODULE_ARCHIVE}" "${MODULE_ARCHIVE_DOWNLOAD_URL}"

# Install module
install_archive_module "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"

# Set module profile
install_module_profile "${MODULE_NAME}" "IDEA_HOME"

# Install module desktop entry
install_module_desktop_entry "${MODULE_NAME}" "${MODULE_DESCRIPTION}" "${MODULE_EXECUTABLE}" "${MODULE_ICON}" "${MODULE_CATEGORIES}"
