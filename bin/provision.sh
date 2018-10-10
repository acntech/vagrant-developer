#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/.common"

#initialize

#install_module "rng"
#install_module "git"
#install_module "docker"
install_module "java"
install_module "maven"

#finalize
