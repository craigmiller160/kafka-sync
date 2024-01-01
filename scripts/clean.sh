#!/bin/bash

. ./utils.sh

clean_local_data() {
  echo "Cleaning local data"
  rm ./producer/database.json 2>/dev/null
  rm ./consumer/database.json 2>/dev/null
  rm -rf ./docker/kafka/config 2>/dev/null
  rm -rf ./docker/kafka/data 2>/dev/null
}

docker_stop() {
  echo "Stopping docker applications"
  docker compose stop
  check_command_status $?
}

docker_prune() {
  echo -n "Do you want to prune the docker system? (y/n) "
  read -r do_docker_prune

  if [ "$do_docker_prune" == "y" ]; then
    docker \
      system \
      prune \
      --all \
      --volumes \
      -f
  fi
}

docker_stop
clean_local_data
docker_prune