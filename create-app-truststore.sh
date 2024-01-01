#!/bin/sh

ROOT_TRUSTSTORE_PATH="$JAVA_HOME/libexec/openjdk.jdk/Contents/Home/lib/security/cacerts"

function create_app_truststore {
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