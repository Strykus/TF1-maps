# TF1 Map Audio Runtime

`ns_audio.cpp` is the source for [TF1AudioRuntime.dll](../TF1AudioRuntime.dll).
The plugin plays ambience and positional sounds for ported Titanfall maps via
XAudio2. It uses the Northstar plugin API and checks the retail Titanfall 2
`client.dll` hash before registering client script functions.

## Build

Install Visual Studio 2022 with the Desktop development with C++ workload and
a Windows SDK. Open the **x64 Native Tools Command Prompt for VS 2022** in this
directory and run:

```bat
build_audio.cmd
```

The compiled DLL is written to `build\TF1AudioRuntime.dll`. The build uses
MSVC and the Windows SDK libraries for XAudio2, OLE, BCrypt, and User32.

The SHA-256 of the DLL checked into this repository is
`0e7525e10e40018479752d131c9fcb665675ccc21628e37e8c5b5ee672d250ce`.
The published DLL and local rebuild used different MSVC patch versions and
have different binary hashes.
