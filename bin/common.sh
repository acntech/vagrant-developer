#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"
SCRIPT_LOG="/tmp/vagrant-provisioning.log"

PROVISIONING_FLAG="/var/local/.vagrant-provisioning"

DEFAULT_USER="vagrant"

MODULE_ROOT_DIR="/opt"
MODULE_DESKTOP_ENTRY_ROOT_DIR="/usr/share/applications"
MODULE_EXECUTABLE_ROOT_DIR="/usr/bin"
MODULE_PROFILE_ROOT_DIR="/etc/profile.d"
MODULE_APT_REPO_LIST_DIR="/etc/apt/sources.list.d"
MODULE_TEMP_DIR="/tmp"
MODULE_DEFAULT_SYMLINK="default"


#
# Function for adding user to group
#
function add_user_to_group() {
    local group="$1"
    local user="${2:-${DEFAULT_USER}}"

    log " "

    if [ -z "${group}" ]; then
        log " ERROR: No group specified"
        exit 1
    fi

    c=$(groups "${user}" | grep -c -e "\s${group}\s")
    if [ $c -gt 0 ]; then
        log " User ${user} already assigned to group ${group}"
    else
        log " Adding user ${user} to group ${group}"
        usermod -a -G "${group}" "${user}"
    fi
}


#
# Function for adding APT key
#
function add_apt_key() {
    local module="$1"
    local url="$2"

    local key_file_path="${MODULE_TEMP_DIR}/${module}.key"

    log " "

    if [ -z "${url}" ]; then
        log " ERROR: No APT key URL specified"
        exit 1
    fi

    log " Adding APT key for module ${module}"
    curl -fsSL "${url}" -o "${key_file_path}"
    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true
    apt-key add "${key_file_path}" >> "${SCRIPT_LOG}" 2>&1
    rm "${key_file_path}"
}


#
# Function for adding APT repository
#
function add_apt_repo() {
    local module="$1"
    local repo="$2"
    local src_repo="$3"

    local repo_list="${MODULE_APT_REPO_LIST_DIR}/${module}.list"

    log " "

    if [ -z "${module}" ]; then
        log " ERROR: No module specified"
        exit 1
    fi

    if [ -z "${repo}" ]; then
        log " ERROR: No APT repository specified"
        exit 1
    fi

    if [ -f "${repo_list}" ]; then
        log " APT repository for module ${module} already exists"
    else
        log " Adding APT repository for module ${module}"
        
        echo "${repo}" > "${repo_list}"
        if [ ! -z "${src_repo}" ]; then
            echo "${src_repo}" >> "${repo_list}"
        fi
        apt-get update >> "${SCRIPT_LOG}" 2>&1
    fi
}


#
# Function for updating APT packages
#
function update_apt() {
    log " "
    log " Updating APT packages, please wait..."
    apt-get update >> "${SCRIPT_LOG}" 2>&1
    apt-get -y -o Dpkg::Options::="--force-confdef" upgrade >> "${SCRIPT_LOG}" 2>&1
    apt-get -y dist-upgrade >> "${SCRIPT_LOG}" 2>&1
}


#
# Function for installing en APT package
#
function install_apt() {
    local package="$1"

    log " "

    if [ -z "${package}" ]; then
        log " ERROR: No APT package specified"
        exit 1
    fi

    c=$(dpkg -l | grep -c -e "\s${package}\s" || true)
    if [ $c -gt 0 ]; then
        log " APT package ${package} is already installed"
    else
        log " Installing APT package ${package}"
        apt-get -y install "${package}" >> "${SCRIPT_LOG}" 2>&1
    fi
}


#
# Function for installing en SNAP package
#
function install_snap() {
    local package="$1"

    log " "

    if [ -z "${package}" ]; then
        log " ERROR: No SNAP package specified"
        exit 1
    fi

    c=$(snap list | awk '{ print $1 }' | grep -c "${package}")
    if [ $c -gt 0 ]; then
        log " SNAP package ${package} is already installed"
    else
        log " Installing SNAP package ${package}"
        snap install "${package}" >> "${SCRIPT_LOG}" 2>&1
    fi
}


#
# Function for clearing APT cache
#
function clear_apt() {
    log " "
    log " Clearing APT cache"
    apt-get -y autoremove >> "${SCRIPT_LOG}" 2>&1
    apt-get -y autoclean >> "${SCRIPT_LOG}" 2>&1
    apt-get -y clean >> "${SCRIPT_LOG}" 2>&1
    rm -rf /var/lib/apt/lists/*
}


#
# Function for clearing disk
#
function clear_disk() {
    log " "
    log " Clearing image disk, please wait..."
    rm -rf "${MODULE_TEMP_DIR}/*"
    dd if=/dev/zero of=/EMPTY bs=1M >> "${SCRIPT_LOG}" 2>&1 || true
    rm -f /EMPTY
}


#
# Function for clearing BASH history
#
function clear_history() {
    log " "
    log " Clearing BASH history"
    cat /dev/null > ~/.bash_history
    history -c
}


#
# Function that is run in the start of provisioning
#
function initialize() {
    log " "
    log " ############################################"
    log " #"
    log " #  Initialize provisioning..."
    log " #"
    log " ############################################"

    update_apt
}


#
# Function that is run in the end of provisioning
#
function finalize() {
    log " "
    log " ############################################"
    log " #"
    log " #  Finalize provisioning..."
    log " #"
    log " ############################################"

    if [ ! -f "${PROVISIONING_FLAG}" ]; then
        clear_apt
        clear_disk
        clear_history
    else
        log " "
        log " Clearing of machine is disabled on already provisioned system"
        log " Delete provision flag ${PROVISIONING_FLAG} to override"
    fi

    date > "${PROVISIONING_FLAG}"

    log " "
    log " ############################################"
    log " #"
    log " #  SUCCESS!"
    log " #  Provisioning complete! Enjoy!"
    log " #"
    log " ############################################"
}


#
# Function for running the install script for a module
#
function install_module() {
    local module="$1"

    log " "
    log " ############################################"
    log " #"
    log " #  Installing module ${module}"
    log " #"
    log " ############################################"

    if [ -z "${module}" ]; then
        log " ERROR: No install candidate specified"
        exit 1
    fi

    if [ ! -f "${SCRIPT_DIR}/${module}/install.sh" ]; then
        log " ERROR: Install candidate ${module} not valid"
        exit 1
    fi

    bash "${SCRIPT_DIR}/${module}/install.sh"
}


#
# Function for checking if the install directory of a module exists
#
function module_install_dir_exist() {
    local module="$1"
    local module_install_dir="$2"

    local module_install_path="${MODULE_ROOT_DIR}/${module}/${module_install_dir}"

    test -d "${module_install_path}"
}


#
# Function for installing a module from an archive
#
function install_archive_module() {
    local module="$1"
    local module_install_dir="$2"
    local module_symlink="${3:-${MODULE_DEFAULT_SYMLINK}}"
    local module_archive_strip="${4:-1}"

    local module_dir="${MODULE_ROOT_DIR}/${module}"
    local module_install_path="${module_dir}/${module_install_dir}"
    local module_symlink_path="${module_dir}/${module_symlink}"
    local module_tar_archive="${MODULE_TEMP_DIR}/${module}.tar.gz"
    local module_zip_archive="${MODULE_TEMP_DIR}/${module}.zip"
    local current_dir="$(pwd)"

    log " "

    if [ -z "${module}" ]; then
        log " ERROR: No module specified"
        exit 1
    fi

    if [ -z "${module_install_dir}" ]; then
        log " ERROR: No module install directory specified"
        exit 1
    fi

    if [ -d "${module_dir}" ]; then
        log " Directory for module ${module} exists, continuing"
    else
        log " Directory for module ${module} does not exist, creating it"
        mkdir "${module_dir}"
    fi

    if [ -d "${module_install_path}" ]; then
        log " Install directory for module ${module} already exists"
        exit 0
    else
        log " Install directory for module ${module} does not exist, creating it"
        mkdir "${module_install_path}"
    fi

    if [ -h "${module_symlink_path}" ]; then
        log " Removing default symbolic link for existing module ${module}"
        rm "${module_symlink_path}"
    fi

    log " Extracting archive for module ${module}"
    if [ -f "${module_tar_archive}" ]; then
        tar -xzf "${module_tar_archive}" --strip "${module_archive_strip}" -C "${module_install_path}"
        rm "${module_tar_archive}"
    elif [ -f "${module_zip_archive}" ]; then
        unzip "${module_zip_archive}" -d "${module_dir}/"
        rm "${module_zip_archive}"
    else
        log " ERROR: No archive found for module ${module} in ${MODULE_TEMP_DIR}"
        exit 1
    fi

    if [ ! -d "${module_install_path}" ]; then
        log " ERROR: No install directory found for module ${module} after extracting archive"
        exit 1
    fi

    log " Installing symlink for module ${module}"
    cd "${module_dir}"
    ln -s "${module_install_dir}" "${module_symlink}"
    cd "${current_dir}"

    chown -R root:root "${module_dir}"
}


#
# Function for installing a desktop entry
#
function install_module_desktop_entry() {
    local module="$1"
    local module_description="$2"
    local module_executable_path="$3"
    local module_icon_path="$4"
    local module_categories="$4"

    local desktop_entry="${module}.desktop"
    local desktop_entry_path="${MODULE_DESKTOP_ENTRY_ROOT_DIR}/${module}.desktop"

    log " "

    if [ -z "${module}" ]; then
        log " ERROR: No module specified"
        exit 1
    fi

    if [ -z "${module_description}" ]; then
        log " ERROR: No module description specified"
        exit 1
    fi

    if [ -z "${module_executable_path}" ]; then
        log " ERROR: No module executable path specified"
        exit 1
    fi

    if [ -z "${module_icon_path}" ]; then
        log " ERROR: No module icon path specified"
        exit 1
    fi

    if [ -z "${module_categories}" ]; then
        log " ERROR: No module categories specified"
        exit 1
    fi

    if [ -f "${desktop_entry_path}" ]; then
        log " Desktop entry for module ${module} already exists"
        exit 0
    fi

    log " Installing desktop entry for module ${module}"
    echo -e "[Desktop Entry]\n \
             Version=1.0\n \
             Name=${module_description}\n \
             Comment=${module_description}\n \
             Exec=env UBUNTU_MENUPROXY= ${module_executable_path}\n \
             Icon=${module_icon_path}\n \
             Terminal=false\n \
             Type=Application\n \
             Categories=${module_categories}\n" > "${desktop_entry_path}"
}


#
# Function for installing a module executable as a system command
#
function install_module_executable() {
    local module="$1"
    local executable="$2"

    local executable_system_path="${MODULE_EXECUTABLE_ROOT_DIR}/${executable}"
    local executable_module_path="${MODULE_ROOT_DIR}/${module}/${MODULE_DEFAULT_SYMLINK}/bin/${executable}"

    log " "

    if [ -z "${module}" ]; then
        log " ERROR: No module specified"
        exit 1
    fi

    if [ -z "${executable}" ]; then
        log " ERROR: No executable specified"
        exit 1
    fi

    if [ ! -f "${executable_module_path}" ]; then
        log " ERROR: Path for executable ${executable} does not exist for module ${module}"
        exit 1
    fi

    log " Installing executable alternatives ${executable} for module ${module}"
    update-alternatives --install "${executable_system_path}" "${executable}" "${executable_module_path}" 1 >> "${SCRIPT_LOG}" 2>&1
    update-alternatives --set "${executable}" "${executable_module_path}" >> "${SCRIPT_LOG}" 2>&1
}


#
# Function for installing a module profile that set environment variables
#
function install_module_profile() {
    local module="$1"
    local environment_variable="$2"
    local environment_variable_alias="$3"

    local module_path="${MODULE_ROOT_DIR}/${module}/${MODULE_DEFAULT_SYMLINK}"
    local module_profile_path="${MODULE_PROFILE_ROOT_DIR}/${module}.sh"
    local module_environment_variable="\nexport ${environment_variable}=${module_path}"

    log " "

    if [ -z "${module}" ]; then
        log " ERROR: No module specified"
        exit 1
    fi

    if [ -z "${environment_variable}" ]; then
        log " ERROR: No environment variable specified"
        exit 1
    fi

    if [ ! -z "${environment_variable_alias}" ]; then
        module_environment_variable="${module_environment_variable}\nexport ${environment_variable_alias}=${module_path}"
    fi

    log " Installing profile for module ${module}"
    echo -e "#!/bin/bash\n${module_environment_variable}\nexport PATH=\${PATH}:\${${environment_variable}}/bin\n" > "${module_profile_path}"
}


#
# Function for downloading a module archive
#
function download_module_archive() {
    local module_archive="$1"
    local module_archive_download_url="$2"
    local module_download_header="$3"

    local module_archive_path="${MODULE_TEMP_DIR}/${module_archive}"

    log " "

    if [ -z "${module_archive}" ]; then
        log " ERROR: No module archive specified"
        exit 1
    fi

    if [ -z "${module_archive_download_url}" ]; then
        log " ERROR: No module archive download URL specified"
        exit 1
    fi

    if [ -f "${module_archive_path}" ]; then
        log " Module archive already exists. Delete it to force new download"
        exit 0
    fi

    log " Downloading module archive, please wait..."
    local success=0
    if [ -z "${module_download_header}" ]; then
        wget --quiet --no-cookies --no-check-certificate "${module_archive_download_url}" -O "${module_archive_path}"
        success=$?
    else
        wget --quiet --no-check-certificate --header="${module_download_header}" "${module_archive_download_url}" -O "${module_archive_path}"
        success=$?
    fi

    if [ "${success}" != 0 ]; then
        log "ERROR: Error occurred when downloading module archive"
        exit 1
    fi
}


#
# Function for installing a system executable
#
function install_system_executable() {
    local executable="$1"
    local executable_url="$2"

    local system_executable_dir="/usr/local/bin"
    local system_executable_path="${system_executable_dir}/${executable}"

    log " "

    if [ -z "${executable}" ]; then
        log " ERROR: No executable specified"
        exit 1
    fi

    if [ -z "${executable_url}" ]; then
        log " ERROR: URL for executable ${executable} does not exist"
        exit 1
    fi

    if [ -f "${system_executable_path}" ]; then
        log " System executable ${executable} already exists"
        exit 0
    fi

    log " Installing system executable ${executable} to ${system_executable_dir}"
    curl -fsSL "${executable_url}" > "${system_executable_path}"
    chmod +x "${system_executable_path}"
}


#
# Functions for logging
#
function log() {
    local message="$1"

    echo "${message}"
    echo "${message}" >> "${SCRIPT_LOG}"
}


#
# Functions to handle errors
#
function on_error() {
    local func="$1"
    local line="$2"

    log " "
    log " ############################################"
    log " #"
    log " #  ERROR!"
    log " #  Provisioning error occurred in function ${func}() on line ${line} of script ${BASH_SOURCE[0]}"
    log " #  See logfile ${SCRIPT_LOG} for more details"
    log " #"
    log " ############################################"
}


#
# Functions to handle interrupts
#
function on_interrupt() {
    log " "
    log " ############################################"
    log " #"
    log " #  INTERRUPTED!"
    log " #  Provisioning was interrupted"
    log " #  See logfile ${SCRIPT_LOG} for more details"
    log " #"
    log " ############################################"
}


#
# Functions to handle errors
#
function on_exit() {
    log " "
}