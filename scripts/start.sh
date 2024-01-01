#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Must provide name of app to start"
  exit 1
fi

case $1 in
  producer|consumer) echo "foo" ;;
  *)
    echo "Invalid name of app to start: $1"
  ;;
esac

(cd "$1" && gradle bootRun)