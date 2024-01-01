#!/bin/bash

. ./utils.sh

CERTS_DIR="$(pwd)/certs"
CA_CERT="$CERTS_DIR/ca.cert.pem"
CA_KEY="$CERTS_DIR/ca_key.pem"
LOCALHOST_CERT_REQ="$CERTS_DIR/localhost.req.pem"
LOCALHOST_CERT="$CERTS_DIR/localhost.cert.pem"
LOCALHOST_KEY="$CERTS_DIR/localhost.key.pem"
VALIDITY_IN_DAYS=3650
PASSWORD=password
KAFKA_TRUSTSTORE="$CERTS_DIR/kafka.truststore.jks"
KAFKA_KEYSTORE="$CERTS_DIR/kafka.keystore.jks"
CERT_SUBJECT="/C=US/ST=Florida/L=Tampa/O=KafkaSync/OU=KafkaSync/CN=localhost"


create_certs_directory() {
  echo "Creating certs directory"
  rm -rf "$CERTS_DIR" 2>/dev/null
  mkdir "$CERTS_DIR"
  check_command_status $?
}

create_ca_cert_and_key() {
  echo "Creating CA certificate & key"
  openssl \
    req \
    -new \
    -x509 \
    -keyout "$CA_KEY" \
    -out "$CA_CERT" \
    -days $VALIDITY_IN_DAYS \
    -subj "$CERT_SUBJECT" \
    -passout "pass:$PASSWORD"
  check_command_status $?
}

create_cert_req() {
  echo "Creating localhost certificate request & key"
  openssl \
    req \
    -newkey \
    rsa:4096 \
    -keyout "$LOCALHOST_KEY" \
    -out "$LOCALHOST_CERT_REQ" \
    -subj "$CERT_SUBJECT" \
    -passout "pass:$PASSWORD"
  check_command_status $?

    openssl \
      x509 \
      -req \
      -CA "$CA_CERT" \
      -CAkey "$CA_KEY" \
      -in "$LOCALHOST_CERT_REQ" \
      -out "$LOCALHOST_CERT" \
      -days "$VALIDITY_IN_DAYS" \
      -CAcreateserial \
      -passin "pass:$PASSWORD"
    check_command_status $?
}

create_kafka_stores() {
  echo "Creating Kafka truststore"
  keytool \
    -keystore "$KAFKA_TRUSTSTORE" \
    -storepass "$PASSWORD" \
    -alias CARoot \
    -import \
    -file "$CA_CERT" \
    -noprompt
  check_command_status $?

  echo "Creating Kafka keystore"
  keytool \
    -keystore "$KAFKA_KEYSTORE" \
    -storepass "$PASSWORD" \
    -alias localhost \
    -import \
    -file "$LOCALHOST_CERT" \
    -noprompt
  check_command_status $?
}

create_certs_directory
create_ca_cert_and_key
create_cert_req
create_kafka_stores