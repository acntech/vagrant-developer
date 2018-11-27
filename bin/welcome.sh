#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

# ASCII art from http://patorjk.com/software/taag

if [ -f "${SCRIPT_DIR}/welcome" ]; then
    cat "${SCRIPT_DIR}/welcome"
fi
echo " "
echo " Starting provisioning of box. This might take some time."
echo " "
