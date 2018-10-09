#!/bin/bash

DOCKER_COMPOSE_VERSION="1.22.0"
OS_NAME="$(uname -s)"
OS_ARCH="$(uname -m)"
OS_FLAVOR="$(lsb_release -cs)"

# Add GPG key for Docker APT repo
curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | apt-key add -
# Add APT repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${OS_FLAVOR} stable"
apt update
# Install Docker CE
apt install docker-ce
# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-${OS_NAME}-${OS_ARCH}" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
