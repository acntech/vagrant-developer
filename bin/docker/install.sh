#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../.common"

MODULE_NAME="docker"

DOCKER_COMPOSE_VERSION="1.22.0"
OS_NAME="$(uname -s)"
OS_ARCH="$(uname -m)"
OS_FLAVOR="$(lsb_release -cs)"

# Add GPG key for Docker APT repo
add_apt_key "${MODULE_NAME}" "https://download.docker.com/linux/ubuntu/gpg"

# Add APT repo
add_apt_repo "${MODULE_NAME}" "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${OS_FLAVOR} stable"

# Install Docker CE
install_apt docker-ce

# Install Docker Compose
curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-${OS_NAME}-${OS_ARCH}" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Add vagrant user to docker group
usermod -a -G docker vagrant
