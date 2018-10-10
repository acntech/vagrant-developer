#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/../.common"

install_apt "rng-tools"

echo -e "\nHRNGDEVICE=/dev/urandom" >> /etc/default/rng-tools
