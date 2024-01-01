#!/bin/sh

function extract {
  keytool \
    -exportcert \
    -alias $1 \
    -keystore $2 \
    -rfc \
    -file $3
}

function decrypt {
  openssl \
    rsa \
    -in $1 \
    -out $2
}

echo "Extracting caroot certificate from truststore"
extract "caroot" "truststore/kafka.truststore.jks" "truststore/caroot.pem"

echo "Decrypting ca-key from truststore"
decrypt "truststore/ca-key" "truststore/ca-key.pem"

echo "Extracting caroot certificate from keystore"
extract "caroot" "keystore/kafka.keystore.jks" "keystore/caroot.pem"

echo "Extracting localhost certificate from keystore"
extract "localhost" "keystore/kafka.keystore.jks" "keystore/localhost.pem"