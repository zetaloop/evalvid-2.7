@echo off
setlocal EnableDelayedExpansion

for %%I in ("%~dp0.") do set "ROOT=%%~fI"
set "OUTDIR=%ROOT%\build\win-x64"
set "VCVARS=C:\Program Files\Microsoft Visual Studio\18\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
set "GPAC_ROOT=C:\Applications\GPAC"
set "GPAC_INC=%GPAC_ROOT%\sdk\include"
set "GPAC_WIN32_INC=%GPAC_ROOT%\sdk\include\win32"
set "GPAC_LIB=%GPAC_ROOT%\sdk\lib"
set "GPAC_BIN=%GPAC_ROOT%"
set "CL_COMMON=/nologo /utf-8 /O2 /DWIN32 /D_CONSOLE /D_CRT_SECURE_NO_WARNINGS"

if not exist "%VCVARS%" (
  echo Missing Visual Studio environment script: %VCVARS%
  exit /b 1
)

if not exist "%GPAC_INC%\gpac\isomedia.h" (
  echo Missing GPAC SDK headers under: %GPAC_INC%
  exit /b 1
)

if not exist "%GPAC_LIB%\libgpac.lib" (
  echo Missing GPAC import library under: %GPAC_LIB%
  exit /b 1
)

call "%VCVARS%"
if errorlevel 1 exit /b %errorlevel%

if exist "%OUTDIR%" rd /s /q "%OUTDIR%"
mkdir "%OUTDIR%"
if errorlevel 1 exit /b %errorlevel%

pushd "%ROOT%"

echo Building mp4trace.exe
cl %CL_COMMON% /I "%ROOT%" /I "%GPAC_INC%" /I "%GPAC_WIN32_INC%" bits.c error.c lock.c misc.c queue.c socket.c thread.c timing.c mp4trace.c /link /OUT:"%OUTDIR%\mp4trace.exe" /LIBPATH:"%GPAC_LIB%" /LIBPATH:"%GPAC_BIN%" ws2_32.lib winmm.lib libgpac.lib || goto :fail

echo Building etmp4.exe
cl %CL_COMMON% /I "%ROOT%" /I "%GPAC_INC%" /I "%GPAC_WIN32_INC%" bits.c misc.c read.c stat.c writemp4.c etmp4.c /link /OUT:"%OUTDIR%\etmp4.exe" /LIBPATH:"%GPAC_LIB%" /LIBPATH:"%GPAC_BIN%" libgpac.lib || goto :fail

echo Building psnr.exe
cl %CL_COMMON% /I "%ROOT%" psnr.c /link /OUT:"%OUTDIR%\psnr.exe" || goto :fail

echo Building hist.exe
cl %CL_COMMON% /I "%ROOT%" stat.c hist.c /link /OUT:"%OUTDIR%\hist.exe" || goto :fail

echo Building mos.exe
cl %CL_COMMON% /I "%ROOT%" dir.c mos.c /link /OUT:"%OUTDIR%\mos.exe" || goto :fail

echo Building miv.exe
cl %CL_COMMON% /I "%ROOT%" dir.c miv.c /link /OUT:"%OUTDIR%\miv.exe" || goto :fail

echo Building eg.exe
cl %CL_COMMON% /I "%ROOT%" misc.c random.c read.c eg.c /link /OUT:"%OUTDIR%\eg.exe" || goto :fail

echo Building vsgen.exe
cl %CL_COMMON% /I "%ROOT%" vsgen.c /link /OUT:"%OUTDIR%\vsgen.exe" || goto :fail

copy /y "%GPAC_BIN%\libgpac.dll" "%OUTDIR%\libgpac.dll" >nul

echo Built binaries in %OUTDIR%
popd
exit /b 0

:fail
popd
exit /b %errorlevel%
