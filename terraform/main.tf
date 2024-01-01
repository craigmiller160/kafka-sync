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
  ca_cert = file("../truststore/kafka.truststore.pem")
  client_cert = file("../keystore/kafka.keystore.pem")
  client_key = file("../truststore/ca-key")
}