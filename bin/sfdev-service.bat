@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

  SET SCRIPT_DIRECTRY=%~dp0
  FOR %%X IN ("%SCRIPT_DIRECTRY%.") DO SET SFDEV_DIR=%%~dpX
  SET SFDEV_DIR=%SFDEV_DIR:~0,-1%
  SET BIN_DIR=%SFDEV_DIR%\bin
  SET WSL_DIR=%SFDEV_DIR%\wsl
  SET DOCKER_SERVICES=
  SET WSL_SERVICES=
  SET SERVICE_TYPE=none

  IF NOT "%~1"=="" (
    IF NOT "%~1"=="start" IF NOT "%~1"=="stop" IF NOT "%~1"=="restart" IF NOT "%~1"=="status" GOTO :HELP

    FOR %%A IN (%*) DO (
      IF NOT "%%A"=="%~1" (
        IF "%%A"=="mysql_master" (
          SET SERVICE_TYPE=docker
        ) ELSE IF "%%A"=="mysql_slave" (
          SET SERVICE_TYPE=docker
        ) ELSE IF "%%A"=="memcached" (
          SET SERVICE_TYPE=docker
        ) ELSE IF "%%A"=="redis" (
          SET SERVICE_TYPE=docker
        ) ELSE IF "%%A"=="elasticsearch_master" (
          SET SERVICE_TYPE=docker
        ) ELSE IF "%%A"=="elasticsearch_slave" (
          SET SERVICE_TYPE=docker
        ) ELSE IF "%%A"=="cron" (
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
        ) ELSE (
          SET SERVICE_TYPE=none
        )

        IF "!SERVICE_TYPE!"=="docker" (
          SET DOCKER_SERVICES=!DOCKER_SERVICES! %%A
        ) ELSE IF "!SERVICE_TYPE!"=="wsl" (
          SET WSL_SERVICES=!WSL_SERVICES! %%A
        )
      )
    )

    IF ""=="!DOCKER_SERVICES!!WSL_SERVICES!" (
      ECHO.
      ECHO.
      ECHO "!BIN_DIR!\sfdev-docker.bat" %~1
      C:\WINDOWS\system32\cmd.exe /C "!BIN_DIR!\sfdev-docker.bat" %~1
      ECHO.
      ECHO.
      ECHO "!BIN_DIR!\wsl-wrapper.bat" sudo !WSL_DIR!\scripts\service.sh %~1
      C:\WINDOWS\system32\cmd.exe /C "!BIN_DIR!\wsl-wrapper.bat" sudo !WSL_DIR!\scripts\service.sh %~1
    ) ELSE (
      IF NOT ""=="!DOCKER_SERVICES!" (
        ECHO.
        ECHO.
        ECHO "!BIN_DIR!\sfdev-docker.bat" %~1 !DOCKER_SERVICES!
        C:\WINDOWS\system32\cmd.exe /C "!BIN_DIR!\sfdev-docker.bat" %~1 !DOCKER_SERVICES!
      )

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
  ECHO   - mysql_master
  ECHO   - mysql_slave
  ECHO   - memcached
  ECHO   - redis
  ECHO   - elasticsearch_master
  ECHO   - elasticsearch_slave
  ECHO   - cron
  ECHO   - ssh
  ECHO   - php5.6-fpm
  ECHO   - php7.2-fpm
  ECHO   - nginx
  ECHO   - blackfire-agent
  ECHO.
  ECHO Examples:
  ECHO   sfdev-service restart
  ECHO   sfdev-service restart mysql_master nginx
  ECHO   sfdev-service restart memcached redis
  GOTO :END

  :END  
ENDLOCAL
