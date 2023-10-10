# `setup_mex`

[![license](https://img.shields.io/badge/license-LGPLv3+-blue)](https://github.com/equipez/setup_mex/blob/main/LICENCE.txt)
[![Test MEX](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml/badge.svg)](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml)
[![View setup_mex on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/127968-setup_mex)

## What

This package provides scripts that attempt to facilitate setting up the
[MATLAB MEX](https://www.mathworks.com/help/matlab/ref/mex.html), focusing on macOS or Windows.
The setup on Linux is trivial and Linuxers should be capable of handling it half asleep.

Not that MATLAB requires you to install a [supported (C or Fortran) compiler along with Xcode (on macOS) 
or Microsoft Visual Studio (on Windows)](https://www.mathworks.com/support/requirements/previous-releases.html). 
This package is **not** a hacking tool to circumvent these requirements,
but a tool to help MATLAB recognize your compiler after these requirements are satisfied.

For Fortran, this package provides scripts (`install_oneapi_macos.sh` and `install_oneapi_windows.bat`) to help
you install the Fortran compiler from 
[Intel oneAPI](https://www.intel.com/content/www/us/en/developer/tools/oneapi/overview.html), 
available free of charge. This is the compiler officially supported by MATLAB. 

This package has been successfully tested on all recent releases of MATLAB under recent versions of Windows and macOS via 
[GitHub Actions](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml). 
Nevertheless, I will not be surprised if it does not work on your machine. In that case,
you need to consult a local MATLAB expert or the technical support
of MathWorks about ["how to set up MEX"](https://www.mathworks.com/help/matlab/ref/mex.html).

## How

Before starting, clone this repository. Then do the following according to your system (macOS or Windows) and your need (C or Fortran).

### macOS

- C

    - Install Xcode with Clang
    - In MATLAB, change the directory to the folder of the repository, run
    ```matlab
    try_mex_setup('c')
    ```

- Fortran

    - Install Xcode with Clang
    - In [terminal](https://support.apple.com/en-hk/guide/terminal/apd5265185d-f365-44cb-8b09-71a064a42125/mac), change the directory to the folder of the repository, run
    ```bash
    sudo bash install_oneapi_macos.sh
    ```
    - In MATLAB, change the directory to the folder of the repository, run
    ```matlab
    try_mex_setup('fortran')
    ```

### Windows

- C

    - Install Microsoft Visual Studio with the "Desktop development with C++" workload
    - In MATLAB, change the directory to the folder of the repository, run
    ```matlab
    try_mex_setup('c')
    ```

- Fortran

    - Install Microsoft Visual Studio with the "Desktop development with C++" workload
    - In [**cmd**](https://en.wikipedia.org/wiki/Cmd.exe) (not [PowerShell](https://en.wikipedia.org/wiki/PowerShell)),  change the directory to the folder of the repository, run
    ```bash
    install_oneapi_windows.bat
    ```
    - In MATLAB, change the directory to the folder of the repository, run
    ```matlab
    try_mex_setup('fortran')
    ```

## Remarks

1. Always adopt the **default options** (e.g., installation directory) when installing Xcode (on macOS) or
   Microsoft Visual Studio (on Windows). Otherwise, MATLAB may not be able to locate them.

2. Choose the version of Xcode or Microsoft Visual Studio according to that of your
   MATLAB, following [the official documentation of MathWorks](https://www.mathworks.com/support/requirements/supported-compilers.html).
   The latest version does not necessarily work.
