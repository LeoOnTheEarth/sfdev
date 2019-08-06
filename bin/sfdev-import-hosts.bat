@ECHO OFF

REM ref: https://sites.google.com/site/eneerge/scripts/batchgotadmin
REM ref: https://gist.github.com/Bomret/0a130778ffbe3a3f0322

REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
IF '%errorlevel%' NEQ '0' (
  GOTO UACPrompt
) ELSE (
  GOTO GotAdmin
)

:UACPrompt
  ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\UACPrompt.vbs"
  SET params = %*:"=""
  ECHO UAC.ShellExecute "cmd.exe", "/C %~s0 %params%", "", "runas", 1 >> "%temp%\UACPrompt.vbs"

  "%temp%\UACPrompt.vbs"
  DEL "%temp%\UACPrompt.vbs"
  EXIT /B

:GotAdmin
  PUSHD "%CD%"
  CD /D "%~dp0"

REM --> Write your scripts below

SET SCRIPT_DIRECTRY=%~dp0
FOR %%X IN ("%SCRIPT_DIRECTRY%.") DO SET SFDEV_DIR=%%~dpX
SET SFDEV_DIR=%SFDEV_DIR:~0,-1%

C:\WINDOWS\system32\cmd.exe /C %~dp0php.bat %SFDEV_DIR%\wsl\scripts\import-hosts.sh

PAUSE
