#!/bin/bash

SCRIPT="$0"
SCRIPT_DIR="$(dirname ${SCRIPT})"

source "${SCRIPT_DIR}/.common"

MODULE_NAME="maven"
MODULE_VERSION="3.5.4"
MODULE_INSTALL_DIR="apache-maven-${MODULE_VERSION}"
MODULE_ARCHIVE="${MODULE_NAME}.tar.gz"
MODULE_ARCHIVE_DOWNLOAD_URL="https://www.apache.org/dist/maven/maven-3/${MODULE_VERSION}/binaries/apache-maven-${MODULE_VERSION}-bin.tar.gz"

# Download JDK
download_module_archive "${MODULE_ARCHIVE}" "${MODULE_ARCHIVE_DOWNLOAD_URL}"

# Install JDK
install_external_module "${MODULE_NAME}" "${MODULE_INSTALL_DIR}"

# Update alternatives for executables
install_module_executable "maven" "mvn"

# Set JAVA_HOME and add binaries to PATH
echo -e "#!/bin/bash\n\nexport MAVEN_HOME=/opt/maven/default\nexport M2_HOME=/opt/maven/default\nexport PATH=\${PATH}:\${MAVEN_HOME}/bin\n" > /etc/profile.d/maven.sh
