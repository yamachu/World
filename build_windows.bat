cd /d %~dp0
if %ARCH% == x86 (
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
) else (
    call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
)
cl.exe /c src\*.cpp tools\*.cpp utils\*.cpp
link.exe /dll /def:world.def *obj /OUT:build\%ARCH%_world.dll