#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../common.sh"
source "${SCRIPT_DIR}/version.sh"

MODULE_NAME="intellij"
MODULE_INSTALL_DIR="${MODULE_EDITION}-${MODULE_VERSION}"
MODULE_ARCHIVE="${MODULE_NAME}.tar.gz"
MODULE_ARCHIVE_DOWNLOAD_URL="https://download.jetbrains.com/idea/${MODULE_EDITION}-${MODULE_VERSION}-no-jdk.tar.gz"
MODULE_DEFAULT_PATH="${MODULE_ROOT_DIR}/${MODULE_NAME}/${MODULE_EDITION}"
MODULE_EXECUTABLE="${MODULE_DEFAULT_PATH}/bin/idea.sh"
MODULE_ICON="${MODULE_DEFAULT_PATH}/bin/idea.png"
MODULE_CATEGORIES="Development;Application;"

if module_install_dir_exist "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"; then
    log " "
    log " Module ${MODULE_NAME} is already installed"
    exit 0
fi

# Download module
download_module_archive "${MODULE_ARCHIVE}" "${MODULE_ARCHIVE_DOWNLOAD_URL}"

# Install module
install_archive_module "${MODULE_NAME}" "${MODULE_INSTALL_DIR}" "${MODULE_EDITION}"

# Set module profile
install_module_profile "${MODULE_NAME}" "IDEA_HOME"

# Install module desktop entry
install_module_desktop_entry "${MODULE_NAME}-${MODULE_EDITION}" "${MODULE_DESCRIPTION}" "${MODULE_EXECUTABLE}" "${MODULE_ICON}" "${MODULE_CATEGORIES}"
