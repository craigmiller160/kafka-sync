#!/bin/bash

CERTS_DIR=../certs
CA_CERT="$CERTS_DIR/ca.cert.pem"
CA_KEY="$CERTS_DIR/ca_key.pem"
VALIDITY_IN_DAYS=3650


create_certs_directory() {
  rm -rf $CERTS_DIR 2>/dev/null
  mkdir $CERTS_DIR
}

create_ca_cert_and_key() {
  openssl \
    req \
    -new \
    -x509 \
    -keyout "$CA_KEY" \
    -out "$CA_CERT" \
    -days $VALIDITY_IN_DAYS
}

create_certs_directory
create_ca_cert_and_key