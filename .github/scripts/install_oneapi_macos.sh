#!/bin/bash
# This script installs the Fortran compilers ifort and ifx provided in Intel OneAPI.
# See https://github.com/oneapi-src/oneapi-ci
# https://github.com/oneapi-src/oneapi-ci/blob/master/scripts/install_macos.sh
#
# OneAPI version: 2023.0.0
#
# Zaikun Zhang (www.zhangzk.net), January 9, 2023

if [[ $# -eq 0 ]]; then
    printf "\n\nUsage: install_oneapi_macos Fortran|C|C++.\n\n"
    exit 1
fi

LG=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if [[ "$LG" != "fortran" && "$LG" != "c" && "$LG" != "c++" && "$LG" != "cpp" ]]; then
    printf "\n\nUsage: install_oneapi_macos Fortran|C|C++.\n\n"
    exit 1
fi

# URL for the offline installer of Intel OneAPI compiler and the components to install. For the URL,
# see
# https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html
if [[ "$LG" = "fortran" ]] ; then
    URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/19106/m_fortran-compiler-classic_p_2023.0.0.25379_offline.dmg
    COMPONENTS=intel.oneapi.mac.ifort-compiler
else
    URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/19097/m_cpp-compiler-classic_p_2023.0.0.25429_offline.dmg
    COMPONENTS=intel.oneapi.mac.cpp-compiler
fi

# Download the installer. curl is included by default in macOS.
cd "$TMPDIR" || exit 2
curl --output webimage.dmg --url "$URL" --retry 5 --retry-delay 5
hdiutil attach webimage.dmg

# Install the compiler.
/Volumes/"$(basename "$URL" .dmg)"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --components="$COMPONENTS" --eula=accept --log-dir=.
installer_exit_code=$?

# Run the script that sets the environment variables.
source /opt/intel/oneapi/setvars.sh

# Show the result of the installation.
if [[ "$LG" = "fortran" ]] ; then
    echo "The latest ifort installed is:"
    ifort --version
    echo "The path to ifort is:"
    command -v ifort
else
    echo "The latest icc installed is:"
    icc --version
    echo "The path to icc is:"
    command -v icc
fi

# Remove the installer
rm webimage.dmg
hdiutil detach /Volumes/"$(basename "$URL" .dmg)" -quiet

# Exit with the installer exit code.
exit $installer_exit_code
