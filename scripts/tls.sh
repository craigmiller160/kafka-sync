#!/bin/bash

CERTS_DIR="$(pwd)/certs"
CA_CERT="$CERTS_DIR/ca.cert.pem"
CA_KEY="$CERTS_DIR/ca_key.pem"
VALIDITY_IN_DAYS=3650
PASSWORD=password
KAFKA_TRUSTSTORE="$CERTS_DIR/kafka.truststore.jks"
KAFKA_KEYSTORE="$CERTS_DIR/kafka.keystore.jks"


create_certs_directory() {
  echo "Creating certs directory"
  rm -rf "$CERTS_DIR" 2>/dev/null
  mkdir "$CERTS_DIR"
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
    -subj "/C=US/ST=Florida/L=Tampa/O=KafkaSync/OU=KafkaSync/CN=localhost" \
    -passout "pass:$PASSWORD"
}

create_stores() {
  echo "Creating Kafka truststore"
  keytool \
    -keystore "$KAFKA_TRUSTSTORE" \
    -alias CARoot \
    -import \
    -file "$CA_CERT"
}

create_certs_directory
create_ca_cert_and_key
create_stores