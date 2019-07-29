@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION
  SET SCRIPT_DIRECTRY=%~dp0
  FOR %%X IN ("%SCRIPT_DIRECTRY%.") DO SET SFDEV_DIR=%%~dpX
  SET SFDEV_DIR=%SFDEV_DIR:~0,-1%
  SET SFDEV_DOCKER_DIR=%SFDEV_DIR%\docker
  SET CURRENT_WORKING_DIR=%CD%

  CD %SFDEV_DOCKER_DIR%

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
      docker-compose -f docker-compose.yml up -d
    ) ELSE (
      docker-compose -f docker-compose.yml start !SERVICES!
    )

    ECHO.
    docker-compose -f docker-compose.yml ps

    GOTO :END
  ) ELSE IF "!ACTION!"=="stop" (
    IF [!SERVICES!]==[] (
      docker-compose -f docker-compose.yml down
      docker system prune -f
      docker volume prune -f
      docker system df
    ) ELSE (
      docker-compose -f docker-compose.yml stop !SERVICES!
    )
    
    ECHO.
    docker-compose -f docker-compose.yml ps

    GOTO :END
  ) ELSE IF "!ACTION!"=="restart" (
  	IF [!SERVICES!]==[] (
      :loop
      ping 127.0.0.1 -n 2 > nul
      docker-compose ps
      IF !errorlevel! GTR 0 (
        ECHO Waiting for docker service start...
        GOTO loop
      )

      docker-compose -f docker-compose.yml down
      docker system prune -f
      docker volume prune -f
      docker system df

      docker-compose -f docker-compose.yml up -d
    ) ELSE (
      docker-compose -f docker-compose.yml restart !SERVICES!
    )
    
    ECHO.
    docker-compose -f docker-compose.yml ps

    GOTO :END
  ) ELSE IF "!ACTION!"=="status" (
    docker-compose -f docker-compose.yml ps
    GOTO :END
  ) ELSE IF "!ACTION!"=="logs" (
    docker-compose -f docker-compose.yml logs
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
