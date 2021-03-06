@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

  SET SCRIPT_DIRECTRY=%~dp0
  FOR %%X IN ("%SCRIPT_DIRECTRY%.") DO SET SFDEV_DIR=%%~dpX
  SET SFDEV_DIR=%SFDEV_DIR:~0,-1%
  SET BIN_DIR=%SFDEV_DIR%\bin
  SET WSL_DIR=%SFDEV_DIR%\wsl
  SET WSL_SERVICES=
  SET SERVICE_TYPE=none

  IF NOT "%~1"=="" (
    IF NOT "%~1"=="start" IF NOT "%~1"=="stop" IF NOT "%~1"=="restart" IF NOT "%~1"=="status" GOTO :HELP

    FOR %%A IN (%*) DO (
      IF NOT "%%A"=="%~1" (
        IF "%%A"=="cron" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="ssh" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="php5.6-fpm" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="php7.2-fpm" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="nginx" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="blackfire-agent" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="memcached" (
          SET SERVICE_TYPE=wsl
        ) ELSE IF "%%A"=="redis-server" (
          SET SERVICE_TYPE=wsl
        ) ELSE (
          SET SERVICE_TYPE=none
        )

        IF "!SERVICE_TYPE!"=="wsl" (
          SET WSL_SERVICES=!WSL_SERVICES! %%A
        )
      )
    )

    IF ""=="!WSL_SERVICES!" (
      ECHO.
      ECHO.
      ECHO "!BIN_DIR!\wsl-wrapper.bat" sudo !WSL_DIR!\scripts\service.sh %~1
      C:\WINDOWS\system32\cmd.exe /C "!BIN_DIR!\wsl-wrapper.bat" sudo !WSL_DIR!\scripts\service.sh %~1
    ) ELSE (
      IF NOT ""=="!WSL_SERVICES!" (
        ECHO.
        ECHO.
        FOR %%A IN (!WSL_SERVICES!) DO (
          ECHO "!BIN_DIR!\wsl-wrapper.bat" sudo !WSL_DIR!\scripts\service.sh %%A %~1
          C:\WINDOWS\system32\cmd.exe /C "!BIN_DIR!\wsl-wrapper.bat" sudo !WSL_DIR!\scripts\service.sh %%A %~1
        )
      )
    )
    GOTO :END
  ) ELSE (
    GOTO :HELP
  )

:HELP
  ECHO Usage: sfdev-service start^|stop^|restart^|status [service1 service2 service3]
  ECHO.
  ECHO Commands:
  ECHO   - sfdev-service start [service1 service2 service3]
  ECHO   - sfdev-service stop [service1 service2 service3]
  ECHO   - sfdev-service restart [service1 service2 service3]
  ECHO   - sfdev-service status
  ECHO.
  ECHO Available services:
  ECHO   - cron
  ECHO   - ssh
  ECHO   - php5.6-fpm
  ECHO   - php7.2-fpm
  ECHO   - nginx
  ECHO   - blackfire-agent
  ECHO   - memcached
  ECHO   - redis-server
  ECHO.
  ECHO Examples:
  ECHO   sfdev-service restart
  ECHO   sfdev-service restart nginx
  ECHO   sfdev-service restart memcached redis
  GOTO :END

  :END  
ENDLOCAL
