@ECHO OFF

SET SCRIPT_DIRECTRY=%~dp0
FOR %%X IN ("%SCRIPT_DIRECTRY%.") DO SET SFDEV_DIR=%%~dpX
SET SFDEV_DIR=%SFDEV_DIR:~0,-1%
SET BIN_DIR=%SFDEV_DIR%\bin
SET WSL_DIR=%SFDEV_DIR%\wsl
SET CURRENT_WORKING_DIR=%CD%

ECHO "%BIN_DIR%\sfdev-docker.bat" restart

c:\WINDOWS\system32\cmd.exe /C "%BIN_DIR%\sfdev-docker.bat" restart

ECHO.
ECHO.
ECHO.

c:\WINDOWS\system32\cmd.exe /C "%BIN_DIR%\wsl-wrapper.bat" sudo %WSL_DIR%\scripts\service.sh restart

cd %CURRENT_WORKING_DIR%
