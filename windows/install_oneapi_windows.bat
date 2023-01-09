REM See https://github.com/oneapi-src/oneapi-ci
REM https://github.com/oneapi-src/oneapi-ci/blob/master/scripts/install_windows.bat

set URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/18529/w_HPCKit_p_2022.1.2.116_offline.exe
set COMPONENTS=intel.oneapi.win.ifort-compiler

curl.exe --output webimage.exe --url %URL% --retry 5 --retry-delay 5
start /b /wait webimage.exe -s -x -f webimage_extracted --log extract.log
del webimage.exe
webimage_extracted\bootstrapper.exe -s --action install --components=%COMPONENTS% --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 --log-dir=.

for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\compiler\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"
@call "C:\Program Files (x86)\Intel\oneAPI\compiler\%LATEST_VERSION%\env\vars.bat"

echo %LATEST_VERSION%
where ifort.exe
where ifx.exe
