#!/bin/bash

docker_start() {
  echo "Starting docker applications"
  docker compose up -d
}

terraform_apply() {
  echo "Running terraform scripts"
  (cd terraform && terraform init -reconfigure && terraform apply)
}


