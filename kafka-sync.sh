#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Must specify command"
  exit 1
fi

case $1 in
  init) bash ./scripts/init.sh ;;
  tls) bash ./scripts/tls.sh ;;
  *)
    echo "Invalid command: $1"
    exit 1
  ;;
esac