resource "kafka_user_scram_credential" "producer_user" {
  username = "producer_user"
  scram_mechanism        = "SCRAM-SHA-256"
  password = "password"
}

resource "kafka_user_scram_credential" "consumer_user" {
  username = "consumer_user"
  scram_mechanism        = "SCRAM-SHA-256"
  password = "password"
}