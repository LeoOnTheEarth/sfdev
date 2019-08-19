@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION
  SET SCRIPT_DIRECTRY=%~dp0
  FOR %%X IN ("%SCRIPT_DIRECTRY%.") DO SET SFDEV_DIR=%%~dpX
  SET SFDEV_DIR=%SFDEV_DIR:~0,-1%
  SET SFDEV_DOCKER_DIR=%SFDEV_DIR%\docker
  SET CURRENT_WORKING_DIR=%CD%
  SET DOCKER_COMPOSE_COMMAND=docker-compose --project-directory "%SFDEV_DOCKER_DIR%" -f "%SFDEV_DOCKER_DIR%\docker-compose.yml"

  ::Get service name list
  SET COUNT=0
  SET ACTION=help
  SET SERVICES=
  FOR %%A IN (%*) DO (
    SET /A COUNT+=1

    IF !COUNT! EQU 1 (
      SET ACTION=%%A
    ) ELSE IF !COUNT! GTR 1 (
      SET SERVICES=!SERVICES! %%A
    )
  )

  IF "!ACTION!"=="start" (
  	IF [!SERVICES!]==[] (
      %DOCKER_COMPOSE_COMMAND% up -d
    ) ELSE (
      %DOCKER_COMPOSE_COMMAND% start !SERVICES!
    )

    ECHO.
    ECHO.
    %DOCKER_COMPOSE_COMMAND% ps

    GOTO :END
  ) ELSE IF "!ACTION!"=="stop" (
    IF [!SERVICES!]==[] (
      %DOCKER_COMPOSE_COMMAND% down
      docker system prune -f
      docker volume prune -f
      docker system df
    ) ELSE (
      %DOCKER_COMPOSE_COMMAND% stop !SERVICES!
    )
    
    ECHO.
    ECHO.
    %DOCKER_COMPOSE_COMMAND% ps

    GOTO :END
  ) ELSE IF "!ACTION!"=="restart" (
  	IF [!SERVICES!]==[] (
      :loop
      ping 127.0.0.1 -n 2 > nul
      %DOCKER_COMPOSE_COMMAND% ps
      IF !errorlevel! GTR 0 (
        ECHO Waiting for docker service start...
        GOTO loop
      )

      ECHO.
      ECHO.

      %DOCKER_COMPOSE_COMMAND% down
      ECHO.
      docker system prune -f
      ECHO.
      docker volume prune -f
      ECHO.
      docker system df
      ECHO.

      %DOCKER_COMPOSE_COMMAND% up -d
    ) ELSE (
      %DOCKER_COMPOSE_COMMAND% restart !SERVICES!
    )
    
    ECHO.
    ECHO.
    %DOCKER_COMPOSE_COMMAND% ps

    GOTO :END
  ) ELSE IF "!ACTION!"=="status" (
    %DOCKER_COMPOSE_COMMAND% ps
    GOTO :END
  ) ELSE IF "!ACTION!"=="logs" (
    %DOCKER_COMPOSE_COMMAND% logs
    GOTO :END
  ) ELSE (
    GOTO :HELP
  )

  :HELP
  ECHO Usage: sfdev-docker start^|stop^|restart^|status [service1 service2 service3]
  ECHO.
  ECHO Commands:
  ECHO   - sfdev-docker start [service1 service2 service3]
  ECHO   - sfdev-docker stop [service1 service2 service3]
  ECHO   - sfdev-docker restart [service1 service2 service3]
  ECHO   - sfdev-docker status
  ECHO.
  ECHO Available services:
  ECHO   - mysql_master
  ECHO   - mysql_slave
  ECHO   - memcached
  ECHO   - redis
  ECHO   - elasticsearch_master
  ECHO   - elasticsearch_slave
  ECHO.
  ECHO Examples:
  ECHO   sfdev-docker restart mysql_master
  ECHO   sfdev-docker restart memcached redis
  GOTO :END

  :END
  CD %CURRENT_WORKING_DIR%
ENDLOCAL
