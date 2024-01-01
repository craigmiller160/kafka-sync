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
    -srckeystore ./certs/kafka.keystore.jks \
    -destkeystore $truststore_path \
    -srcstoretype jks \
    -deststoretype jks \
    -srcstorepass password \
    -deststorepass changeit
}

copy_files() {
  cp "$1/*" "$2"
}

echo "Moving keystore/truststore files to certs directory"
rm -rf certs 2>/dev/null
mkdir certs
copy_files keystore certs
copy_files truststore certs

echo "Creating app truststore for producer"
create_app_truststore "producer"

echo "Creating app truststore for consumer"
create_app_truststore "consumer"

echo "Extracting caroot certificate from truststore"
extract "caroot" "certs/kafka.truststore.jks" "certs/caroot.pem"

echo "Decrypting ca-key from truststore"
decrypt "certs/ca-key" "certs/ca-key.pem"

echo "Extracting localhost certificate from keystore"
extract "localhost" "certs/kafka.keystore.jks" "certs/localhost.pem"