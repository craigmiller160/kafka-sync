#!/bin/bash

docker_start() {
  echo "Starting docker applications"
  docker compose up -d
  check_command_status $?
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