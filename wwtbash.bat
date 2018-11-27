@REM Start a pretty-fully-loaded bash shell using the Conda MSYS2 environment.
@echo off
@REM CALL "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
cd C:\wwt
set PATH=C:\mc3\Library\usr\bin;C:\mc3\Library\mingw-w64\bin;%PATH%
bash
