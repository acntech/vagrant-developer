#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/common.sh"

initialize

#install_module "rng"
install_module "git"
install_module "docker"
install_module "java"
install_module "maven"
install_module "nodejs"
install_module "intellij"
install_module "postman"
install_module "sublime"

finalize
