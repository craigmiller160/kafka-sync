resource "kafka_topic" "person-topic" {
  name               = "person-topic"
  partitions         = 1
  replication_factor = 1
}