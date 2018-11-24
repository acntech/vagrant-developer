#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../common.sh"
source "${SCRIPT_DIR}/version.sh"

MODULE_NAME="node"
MODULE_APT_REPO_URL="https://deb.nodesource.com/node_${MODULE_VERSION}.x"

# Add APT repo
add_apt_repo "${MODULE_NAME}" "deb ${MODULE_APT_REPO_URL} bionic main" "deb-src ${MODULE_APT_REPO_URL} bionic main"

# Install NodeJS
install_apt "nodejs"
