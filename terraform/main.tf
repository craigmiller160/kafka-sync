terraform {
  required_providers {
    kafka = {
      source = "Mongey/kafka"
      version = "0.5.3"
    }
  }
}

provider "kafka" {
  bootstrap_servers = ["localhost:9094"]
  tls_enabled = true
  ca_cert = file("../certs/ca.cert.pem")
  client_cert = file("../certs/localhost.cert.pem")
  client_key = file("../certs/localhost.key.pem")
  skip_tls_verify = true
  sasl_mechanism = "plain"
  sasl_username = "user"
  sasl_password = "password"
}