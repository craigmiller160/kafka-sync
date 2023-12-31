resource "kafka_topic" "person-topic" {
  name               = "person-topic"
  partitions         = 1
  replication_factor = 1
}

resource "kafka_topic" "person-topic-dlt" {
  name               = "person-topic-dlt"
  partitions         = 1
  replication_factor = 1
}