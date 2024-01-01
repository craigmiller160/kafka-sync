#!/bin/bash

. ./scripts/utils.sh

CERTS_DIR="$(pwd)/certs"
CA_CERT="$CERTS_DIR/ca.cert.pem"
CA_KEY_ENC="$CERTS_DIR/ca.key.enc.pem"
CA_KEY_DEC="$CERTS_DIR/ca.key.dec.pem"
LOCALHOST_CERT_REQ="$CERTS_DIR/localhost.req.pem"
LOCALHOST_CERT="$CERTS_DIR/localhost.cert.pem"
LOCALHOST_KEY_ENC="$CERTS_DIR/localhost.key.enc.pem"
LOCALHOST_KEY_DEC="$CERTS_DIR/localhost.key.dec.pem"
VALIDITY_IN_DAYS=3650
PASSWORD=password
KAFKA_TRUSTSTORE="$CERTS_DIR/kafka.truststore.jks"
KAFKA_KEYSTORE="$CERTS_DIR/kafka.keystore.jks"
CERT_SUBJECT="/C=US/ST=Florida/L=Tampa/O=KafkaSync/OU=KafkaSync/CN=localhost"
ROOT_TRUSTSTORE_PATH="$JAVA_HOME/libexec/openjdk.jdk/Contents/Home/lib/security/cacerts"

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
    -keyout "$CA_KEY_ENC" \
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
    -keyout "$LOCALHOST_KEY_ENC" \
    -out "$LOCALHOST_CERT_REQ" \
    -subj "$CERT_SUBJECT" \
    -passout "pass:$PASSWORD"
  check_command_status $?

  openssl \
    x509 \
    -req \
    -CA "$CA_CERT" \
    -CAkey "$CA_KEY_ENC" \
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

create_store_for_app() {
  truststore_path="./$1/src/main/resources/truststore.jks"

  cp "$ROOT_TRUSTSTORE_PATH" "$truststore_path"
  check_command_status $?

  keytool -importkeystore \
    -srckeystore "$KAFKA_KEYSTORE" \
    -destkeystore "$truststore_path" \
    -srcstoretype jks \
    -deststoretype jks \
    -srcstorepass "$PASSWORD" \
    -deststorepass changeit
  check_command_status $?
}

create_app_stores() {
  echo "Creating producer application truststore"
  create_store_for_app "producer"

  echo "Creating consumer application truststore"
  create_store_for_app "consumer"
}

decrypt_key() {
  openssl \
    rsa \
    -in "$1" \
    -out "$2" \
    -passin "pass:$PASSWORD"
  check_command_status $?
}

decrypt_keys() {
  echo "Decrypting CA key"
  decrypt_key "$CA_KEY_ENC" "$CA_KEY_DEC"

  echo "Decrypting localhost key"
  decrypt_key "$LOCALHOST_KEY_ENC" "$LOCALHOST_KEY_DEC"
}

create_certs_directory
create_ca_cert_and_key
create_cert_req
create_kafka_stores
create_app_stores
decrypt_keys