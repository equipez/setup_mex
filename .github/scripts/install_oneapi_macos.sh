#!/bin/bash

URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/18341/m_HPCKit_p_2022.1.0.86_offline.dmg
COMPONENTS=intel.oneapi.mac.ifort-compiler

cd "$TMPDIR" || exit 1
curl --output webimage.dmg --url "$URL" --retry 5 --retry-delay 5
hdiutil attach webimage.dmg
sudo /Volumes/"$(basename "$URL" .dmg)"/bootstrapper.app/Contents/MacOS/bootstrapper -s --action install --components="$COMPONENTS" --eula=accept --log-dir=.
installer_exit_code=$?

source /opt/intel/oneapi/setvars.sh

hdiutil detach /Volumes/"$(basename "$URL" .dmg)" -quiet

exit $installer_exit_code
