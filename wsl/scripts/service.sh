#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
SCRIPT_NAME=`basename "$0"`
ALL_SERVICES=("cron" "ssh" "php5.6-fpm" "php7.2-fpm" "nginx")
ACTION="none"
SERVICE="all"

# With action name Only
if [[ $# -eq 1 ]]
then
  ACTION="$1"
# With action name and service name
elif [[ $# -eq 2 ]]
then
  ACTION="$2"
  SERVICE="$1"
fi

run_one_service () {
  local action="$1"
  local service="$2"

  echo "--------------------------------------------------------------------------------"
  echo "$ service ${service} ${action}"
  echo
  service ${service} ${action}

  if [[ ${action} != "status" ]]
  then
    echo
    sudo /etc/init.d/${service} status
  fi
  echo "--------------------------------------------------------------------------------"
}

run () {
  local action="$1"
  local service="$2"
  local service_exists="0"
  local count=0

  count=0
  while [[ "_${ALL_SERVICES[count]}" != "_" ]]
  do
    if [[ ${service} == "${ALL_SERVICES[count]}" ]]
    then
      service_exists="1"
    fi

    count=$(( $count + 1 ))
  done

  if [[ ${service_exists} -eq "0" ]] && [[ ${service} != "all" ]]
  then
    usage
  fi

  if [[ ${service} == "all" ]]
  then
    count=0
    while [[ "_${ALL_SERVICES[count]}" != "_" ]]
    do
      run_one_service ${action} ${ALL_SERVICES[count]}

      count=$(( $count + 1 ))
    done
  else
    run_one_service ${action} ${service}
  fi
}

usage () {
  echo "Usage: $SCRIPT_NAME [service-name] {start|stop|restart|status}"
  echo
  echo "Process all services when service-name is omitted, or only process the specific service."
  echo
  echo "Supported services:"

  for i in ${ALL_SERVICES[@]}; do
    echo "  - ${i}"
  done

  echo
  echo "Examples:"
  echo "  Start Nginx service:         ${SCRIPT_NAME} nginx start"
  echo "  Restart PHP-FPM 5.6 service: ${SCRIPT_NAME} php5.6-fpm restart"
  echo "  Start ALL services:          ${SCRIPT_NAME} start"
  echo "  Stop ALL services:           ${SCRIPT_NAME} stop"

  exit 1
}

case ${ACTION} in
  start)
    run "start" ${SERVICE}
    run "status" ${SERVICE}
    ;;

  stop)
    run "stop" ${SERVICE}
    run "status" ${SERVICE}
    ;;

  restart)
    run "stop" ${SERVICE}
    run "start" ${SERVICE}
    run "status" ${SERVICE}
    ;;

  status)
    run "status" ${SERVICE}
    ;;

  *)
    usage
esac
