#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../common.sh"
source "${SCRIPT_DIR}/version.sh"

MODULE_NAME="docker"
MODULE_GPG_KEY_URL="https://download.docker.com/linux/ubuntu/gpg"
MODULE_APT_REPO_URL="https://download.docker.com/linux/ubuntu"

DOCKER_COMPOSE_EXECUTABLE="docker-compose"
OS_NAME="$(uname -s)"
OS_ARCH="$(uname -m)"
OS_FLAVOR="$(lsb_release -cs)"
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-${OS_NAME}-${OS_ARCH}"

# Add GPG key for APT repo
add_apt_key "${MODULE_NAME}" "${MODULE_GPG_KEY_URL}"

# Add APT repo
add_apt_repo "${MODULE_NAME}" "deb [arch=amd64] ${MODULE_APT_REPO_URL} ${OS_FLAVOR} stable"

# Install APT package
install_apt "docker-ce"

# Install Docker Compose
install_system_executable "${DOCKER_COMPOSE_EXECUTABLE}" "${DOCKER_COMPOSE_URL}"

# Add vagrant user to docker group
add_user_to_group "docker"
