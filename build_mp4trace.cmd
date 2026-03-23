@echo off
call "C:\Program Files\Microsoft Visual Studio\18\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit /b %errorlevel%

cl /nologo /O2 /DWIN32 /D_CONSOLE /D_CRT_SECURE_NO_WARNINGS /I . /I "C:\Applications\GPAC\sdk\include" /I "C:\Applications\GPAC\sdk\include\win32" bits.c error.c lock.c misc.c queue.c socket.c thread.c timing.c mp4trace.c /link /OUT:mp4trace-x64.exe /LIBPATH:"C:\Applications\GPAC\sdk\lib" /LIBPATH:"C:\Applications\GPAC" ws2_32.lib winmm.lib libgpac.lib
exit /b %errorlevel%
