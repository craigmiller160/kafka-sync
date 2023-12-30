#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Must provide name of app to start"
  exit 1
fi

(cd $1 && gradle bootRun)