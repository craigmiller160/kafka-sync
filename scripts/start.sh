#!/bin/bash

run_app() {
  echo "Running $1 application"
  (cd "$1" && gradle bootRun)
}

if [ $# -ne 1 ]; then
  echo "Must provide name of app to start"
  exit 1
fi

case $1 in
  producer|consumer) run_app "$1" ;;
  *)
    echo "Invalid name of app to start: $1"
  ;;
esac
