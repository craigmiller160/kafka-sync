terraform {
  required_providers {
    kafka = {
      source = "Mongey/kafka"
      version = "0.5.3"
    }
  }
}

provider "kafka" {
  bootstrap_servers = ["localhost:29092"]
  tls_enabled = false
}

resource "kafka_topic" "person-topic" {
  name               = "person-topic"
  partitions         = 1
  replication_factor = 1
}