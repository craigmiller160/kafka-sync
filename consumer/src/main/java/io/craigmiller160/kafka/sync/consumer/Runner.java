package io.craigmiller160.kafka.sync.consumer;

import lombok.SneakyThrows;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.net.ssl.HttpsURLConnection;

@SpringBootApplication
public class Runner {
    @SneakyThrows
    public static void main(final String[] args) {
        final var truststore = Runner.class.getClassLoader().getResource("truststore.jks").toURI().getPath();
        System.setProperty("javax.net.ssl.trustStore", truststore);
        System.setProperty("javax.net.ssl.trustStorePassword", "changeit");
        HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);
        SpringApplication.run(Runner.class, args);
    }
}
