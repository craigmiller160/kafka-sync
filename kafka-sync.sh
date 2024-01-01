#!/bin/bash

. ./scripts/utils.sh

if [ $# -ne 1 ]; then
  echo "Must specify command"
  exit 1
fi

case $1 in
  init) bash ./scripts/init.sh ;;
  clean) bash ./scripts/clean.sh ;;
  start) bash ./scripts/start.sh ;;
  *)
    echo "Invalid command: $1"
    exit 1
  ;;
esac

check_command_status $?