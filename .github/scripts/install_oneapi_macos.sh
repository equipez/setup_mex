#!/bin/bash
# This script installs the Fortran compilers ifort and ifx provided in Intel OneAPI.
# See https://github.com/oneapi-src/oneapi-ci
# https://github.com/oneapi-src/oneapi-ci/blob/master/scripts/install_macos.sh
#
# OneAPI version: 2023.0.0
#
# Zaikun Zhang (www.zhangzk.net), January 9, 2023

# URL for the offline installer of Intel OneAPI Fortran compiler. See
# https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html
URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/19106/m_fortran-compiler-classic_p_2023.0.0.25379_offline.dmg
COMPONENTS=intel.oneapi.mac.ifort-compiler

# Download the installer.
cd "$TMPDIR" || exit 1
curl --output webimage.dmg --url "$URL" --retry 5 --retry-delay 5
hdiutil attach webimage.dmg

# Install the compiler.
/Volumes/"$(basename "$URL" .dmg)"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --components="$COMPONENTS" --eula=accept --log-dir=.
installer_exit_code=$?

# Run the script that sets the environment variables.
source /opt/intel/oneapi/setvars.sh

# Show the result of the installation.
echo "The latest Intel OneAPI installed is:"
ifort --version
echo "The path to ifort is:"
command -v ifort

# Remove the installer
hdiutil detach /Volumes/"$(basename "$URL" .dmg)" -quiet
rm webimage.dmg

exit $installer_exit_code
