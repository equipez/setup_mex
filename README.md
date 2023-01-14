# `setup_mex`

[![license](https://img.shields.io/badge/license-LGPLv3+-blue)](https://github.com/equipez/setup_mex/blob/main/LICENCE.txt)
[![Test MEX](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml/badge.svg)](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml)

## What

This package provides scripts that attempt to facilitate setting up the
[MATLAB MEX](https://www.mathworks.com/help/matlab/ref/mex.html) on macOS or Windows.
The setup on Linux is trivial and Linuxers should be capable of handling it half asleep.

Whether the method here works or not, it depends on the configuration of your system and your MATLAB.
Trying will not hurt. In case it fails, you need to consult a local MATLAB expert or the technical support
of MathWorks about ["how to set up MEX"](https://www.mathworks.com/help/matlab/ref/mex.html).

## Remarks

1. Always adopt the **default options** (e.g., installation directory) when installing Xcode or
   Microsoft Visual Studio. Otherwise, MATLAB may not be able to locate them.

2. Choose the version of Xcode or Microsoft Visual Studio according to that of your
   MATLAB, following [the official documentation of MathWorks](https://www.mathworks.com/support/requirements/supported-compilers.html).
   The latest version does not necessarily work.

## How

Before starting, clone this repository, open your [terminal on macOS](https://en.wikipedia.org/wiki/List_of_macOS_built-in_apps#Terminal)
or [cmd on Windows](https://en.wikipedia.org/wiki/Cmd.exe), and
change the directory to the folder of the repository.

### macOS

- C

    - Install Xcode with Clang
    - In MATLAB, run
    ```
    try_mex_setup('C')
    ```

- Fortran

    - Install Xcode with Clang
    - In terminal, run
    ```
    sudo bash install_oneapi_macos.sh
    ```
    - In MATLAB, run
    ```
    try_mex_setup('Fortran')
    ```

### Windows

- C

    - Install Microsoft Visual Studio with the "Desktop development with C++" workload
    - In MATLAB, run
    ```
    try_mex_setup('C')
    ```

- Fortran

    - Install Microsoft Visual Studio with the "Desktop development with C++" workload
    - In **cmd** (not [PowerShell](https://en.wikipedia.org/wiki/PowerShell)), run
    ```
    install_oneapi_windows.bat
    ```
    - In MATLAB, run
    ```
    try_mex_setup('Fortran')
    ```
