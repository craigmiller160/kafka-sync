#!/bin/bash

. ./scripts/utils.sh

wait_for_kafka() {
  echo "Waiting for kafka to start up"
  for i in {1..10}; do
    response=$(curl localhost:9094 2>&1 | tail -n 1 | grep -c HTTP/0.9)
    if [ $response -eq 1 ]; then
      break
    fi

    sleep 1
  done

  echo "Kafka failed to start before the timeout"
  exit 1
}

docker_start() {
  echo "Starting docker applications"
  docker compose up -d
  check_command_status $?

  echo "Waiting 5 seconds for Kafka to finish starting"
  sleep 5
}

terraform_apply() {
  echo "Running terraform scripts"
  (cd terraform && terraform init -reconfigure && terraform apply)
  check_command_status $?
}

generate_tls() {
  do_generate_tls=""
  echo -n "Do you want to generate TLS certificates? (y/n) "
  read -r do_generate_tls
  check_command_status $?

  if [ "$do_generate_tls" == "y" ]; then
    echo "Generating TLS certificates"
    bash ./scripts/tls.sh
    check_command_status $?
  fi
}

generate_tls
docker_start
terraform_apply