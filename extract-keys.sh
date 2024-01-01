#!/bin/sh

function extract {
  keytool \
    -exportcert \
    -alias $1 \
    -keystore $2 \
    -rfc \
    -file $3
}

echo "Extracting certificate from truststore"
extract "caroot" "truststore/kafka.truststore.jks" "truststore/caroot.pem"

echo "Extracting certificate from keystore"
extract "caroot" "keystore/kafka.keystore.jks" "keystore/caroot.pem"

echo "Extracting key from keystore"
extract "localhost" "keystore/kafka.keystore.jks" "keystore/localhost.pem"