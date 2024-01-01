#!/bin/sh

function create_app_truststore {
  keytool -importkeystore \
  	-srckeystore ./keystore/kafka.keystore.jks \
  	-destkeystore ./$1/src/main/resources/truststore.jks \
  	-srcstoretype jks \
  	-deststoretype jks \
  	-srcstorepass password \
  	-deststorepass changeit
}

echo "Creating app truststore for producer"
create_app_truststore "producer"

echo "Creating app truststore for consumer"
create_app_truststore "consumer"