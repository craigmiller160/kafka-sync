#!/bin/bash

check_command_status() {
  if [ $1 -ne 0 ]; then
    echo "Command failed, aborting script"
    exit 1
  fi
}

export -f check_command_status