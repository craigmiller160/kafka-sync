#!/bin/sh

ROOT_TRUSTSTORE_PATH="$JAVA_HOME/libexec/openjdk.jdk/Contents/Home/lib/security/cacerts"

extract() {
  keytool \
    -exportcert \
    -alias $1 \
    -keystore $2 \
    -rfc \
    -file $3
}

decrypt() {
  openssl \
    rsa \
    -in $1 \
    -out $2
}

create_app_truststore() {
  truststore_path=./$1/src/main/resources/truststore.jks

  cp $ROOT_TRUSTSTORE_PATH $truststore_path

  keytool -importkeystore \
    -srckeystore ./keystore/kafka.keystore.jks \
    -destkeystore $truststore_path \
    -srcstoretype jks \
    -deststoretype jks \
    -srcstorepass password \
    -deststorepass changeit
}

echo "Creating app truststore for producer"
create_app_truststore "producer"

echo "Creating app truststore for consumer"
create_app_truststore "consumer"

echo "Extracting caroot certificate from truststore"
extract "caroot" "truststore/kafka.truststore.jks" "truststore/caroot.pem"

echo "Decrypting ca-key from truststore"
decrypt "truststore/ca-key" "truststore/ca-key.pem"

echo "Extracting caroot certificate from keystore"
extract "caroot" "keystore/kafka.keystore.jks" "keystore/caroot.pem"

echo "Extracting localhost certificate from keystore"
extract "localhost" "keystore/kafka.keystore.jks" "keystore/localhost.pem"