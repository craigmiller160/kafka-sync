#!/bin/bash

docker_start() {
  echo "Starting docker applications"
  docker compose up -d
}

terraform_apply() {
  echo "Running terraform scripts"
  (cd terraform && terraform init -reconfigure && terraform apply)
}

generate_tls() {
  do_generate_tls=""
  echo -n "Do you want to generate TLS certificates?"

  echo "Generating TLS certificates"
  (cd scripts && bash kafka-generate-ssl.sh && bash kafka-ssl-postprocess.sh)
}

docker_start
terraform_apply
generate_tls