# `setup_mex`

[![license](https://img.shields.io/badge/license-LGPLv3+-blue)](https://github.com/equipez/setup_mex/blob/main/LICENCE.txt)
[![Test MEX](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml/badge.svg)](https://github.com/equipez/setup_mex/actions/workflows/setup_mex.yml)

## What

This package provides scripts that attempt to facilitate setting up the
[MATLAB MEX](https://www.mathworks.com/help/matlab/ref/mex.html) on macOS or Windows.
The setup on Linux is trivial and Linuxers should be capable of handling it half asleep.

Whether the methods here will work or not, it depends on the configuration of your system and your MATLAB.
It does not hurt to try.

## Remarks

1. Always adopt the default options (e.g., installation directory) when installing Xcode or
   Microsoft Visual Studio. Otherwise, MATLAB may not be able to locate them.

2. Choose the version of Xcode or Microsoft Visual Studio according to the version of your
   MATLAB, following [the official documentation of MathWorks](https://www.mathworks.com/support/requirements/supported-compilers.html).
   The latest version does not necessarily work.

Before starting, clone this repository, open your terminal (on macOS) or cmd (on Windows), and
change the directory to the folder of the repository.

## How

### macOS

- To compile C MEX files

    - Install Xcode with Clang
    - In MATLAB, run
    ```
    try_mex_setup('C')
    ```

- To compile Fortran MEX files

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

- To compile C MEX files

    - Install Microsoft Visual Studio with the "Desktop development with C++" workload
    - In MATLAB, run
    ```
    try_mex_setup('C')
    ```

- To compile Fortran MEX files

    - Install Microsoft Visual Studio with the "Desktop development with C++" workload
    - In cmd, run
    ```
    install_oneapi_windows.bat
    ```
    - In MATLAB, run
    ```
    try_mex_setup('Fortran')
    ```
