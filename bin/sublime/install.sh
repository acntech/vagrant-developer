#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../common.sh"

MODULE_NAME="sublime"
MODULE_GPG_KEY_URL="https://download.sublimetext.com/sublimehq-pub.gpg"
MODULE_APT_REPO_URL="https://download.sublimetext.com"

# Add GPG key for APT repo
add_apt_key "${MODULE_NAME}" "${MODULE_GPG_KEY_URL}"

# Add APT repo
add_apt_repo "${MODULE_NAME}" "deb ${MODULE_APT_REPO_URL} apt/stable/"

# Install APT package
install_apt "sublime-text"
