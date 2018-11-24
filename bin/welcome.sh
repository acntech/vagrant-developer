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
echo " If the provisioning log contains any error message then something has failed."
echo " "
echo " See logfile /tmp/vagrant-provisioning.log for more details."
echo " "
