#!/bin/bash

case $1 in
  init) bash ./scripts/init.sh ;;
  *)
    echo "Invalid command: $1"
    exit 1
  ;;
esac