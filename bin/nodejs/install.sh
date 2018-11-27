#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../common.sh"
source "${SCRIPT_DIR}/version.sh"

NODE_MODULE_NAME="nodejs"
NODE_MODULE_GPG_KEY_URL="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
NODE_MODULE_APT_REPO_URL="https://deb.nodesource.com/node_${MODULE_VERSION}.x"
YARN_MODULE_NAME="yarn"
YARN_MODULE_GPG_KEY_URL="https://dl.yarnpkg.com/debian/pubkey.gpg"
YARN_MODULE_APT_REPO_URL="https://dl.yarnpkg.com/debian"

# Add GPG key for APT repo
add_apt_key "${NODE_MODULE_NAME}" "${NODE_MODULE_GPG_KEY_URL}"
add_apt_key "${YARN_MODULE_NAME}" "${YARN_MODULE_GPG_KEY_URL}"

# Add APT repo
add_apt_repo "${NODE_MODULE_NAME}" "deb ${NODE_MODULE_APT_REPO_URL} bionic main" "deb-src ${NODE_MODULE_APT_REPO_URL} bionic main"
add_apt_repo "${YARN_MODULE_NAME}" "deb ${YARN_MODULE_APT_REPO_URL} stable main"

# Install APT packages
install_apt "nodejs"
install_apt "nodejs-legacy"
install_apt "npm"
install_apt "yarn"
