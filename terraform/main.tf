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
  ca_cert = file("../truststore/caroot.pem")
  client_cert = file("../truststore/caroot.pem")
  client_key = file("../truststore/ca-key.pem")
  skip_tls_verify = true
}