:: This script installs the Fortran compilers ifort and ifx provided in Intel OneAPI.
:: See https://github.com/oneapi-src/oneapi-ci
:: https://github.com/oneapi-src/oneapi-ci/blob/master/scripts/install_windows.bat
::
:: Zaikun Zhang (www.zhangzk.net), January 9, 2023

:: URL for the offline installer of Intel OneAPI Fortran compiler. See
:: https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-standalone-components.html
set URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/19107/w_fortran-compiler_p_2023.0.0.25579_offline.exe

:: Component to install.
set COMPONENTS=intel.oneapi.win.ifort-compiler

:: Install the compiler.
cd %Temp%
curl.exe --output webimage.exe --url %URL% --retry 5 --retry-delay 5
start /b /wait webimage.exe -s -x -f webimage_extracted --log extract.log
del webimage.exe
webimage_extracted\bootstrapper.exe -s --action install --components=%COMPONENTS% --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.

:: Run the script that sets the environment variables.
for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\compiler\" ^| findstr /V latest ^| sort`) do @set "LATEST_ONEAPI_VERSION=%%f"
@call "C:\Program Files (x86)\Intel\oneAPI\compiler\%LATEST_ONEAPI_VERSION%\env\vars.bat"

:: Show the result of the installation.
echo "The latest Intel OneAPI installed is:"
echo %LATEST_ONEAPI_VERSION%
echo "The path to ifort is:"
where ifort.exe
echo "The path to ifx is:"
where ifx.exe

:: Remove the `webimage_extracted` directory.
rd /s/q "webimage_extracted"

:: Exit with the installer exit code.
set installer_exit_code=%ERRORLEVEL%
exit /b %installer_exit_code%
