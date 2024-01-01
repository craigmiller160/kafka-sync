resource "kafka_acl" "producer_user_person_topic_acl" {
  acl_host            = "*"
  acl_operation       = "Write"
  acl_permission_type = "Allow"
  acl_principal       = "User:producer_user"
  resource_name       = "person-topic"
  resource_type       = "Topic"
}

resource "kafka_acl" "consumer_user_person_topic_acl" {
  acl_host            = "*"
  acl_operation       = "Read"
  acl_permission_type = "Allow"
  acl_principal       = "User:consumer_user"
  resource_name       = "person-topic"
  resource_type       = "Topic"
}

resource "kafka_acl" "consumer_user_person_topic_dlt_acl" {
  acl_host            = "*"
  acl_operation       = "Write"
  acl_permission_type = "Allow"
  acl_principal       = "User:consumer_user"
  resource_name       = "person-topic"
  resource_type       = "Topic"
}