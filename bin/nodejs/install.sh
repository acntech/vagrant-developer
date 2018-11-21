#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../.common"

MODULE_NAME="node"
MODULE_APT_REPO_URL="https://deb.nodesource.com/node_10.x"

# Add APT repo
add_apt_repo "${MODULE_NAME}" "deb ${MODULE_APT_REPO_URL} bionic main" "deb-src ${MODULE_APT_REPO_URL} bionic main"

# Install NodeJS
install_apt "nodejs"
