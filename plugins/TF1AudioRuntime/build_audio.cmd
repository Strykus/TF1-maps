@echo off
setlocal

if /i not "%VSCMD_ARG_TGT_ARCH%"=="x64" (
    echo Run this script from the x64 Native Tools Command Prompt for Visual Studio 2022. 1>&2
    exit /b 1
)

set "output=%~dp0build"
if not exist "%output%" mkdir "%output%"
if not exist "%output%" exit /b 1

cl /nologo /LD /EHsc /std:c++17 /MT /O2 "%~dp0ns_audio.cpp" /Fo"%output%\ns_audio.obj" /Fe"%output%\TF1AudioRuntime.dll" /link xaudio2.lib ole32.lib bcrypt.lib user32.lib
exit /b %errorlevel%
