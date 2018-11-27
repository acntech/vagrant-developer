#!/bin/bash

set -e # Exit on error
set -o errtrace # Trace errors to functions

trap 'on_exit' EXIT
trap 'on_error ${FUNCNAME} ${LINENO}' ERR
trap 'on_interrupt' SIGINT SIGTERM

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/common.sh"

initialize

install_module "git"
install_module "docker"
install_module "java"
install_module "maven"
install_module "nodejs"
install_module "intellij"
install_module "postman"
install_module "sublime"

finalize
