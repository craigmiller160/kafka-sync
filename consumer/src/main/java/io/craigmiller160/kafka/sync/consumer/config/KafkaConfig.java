package io.craigmiller160.kafka.sync.consumer.config;

import org.apache.kafka.common.TopicPartition;
import org.springframework.boot.autoconfigure.kafka.KafkaProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.KafkaOperations;
import org.springframework.kafka.listener.DeadLetterPublishingRecoverer;
import org.springframework.kafka.listener.DefaultErrorHandler;
import org.springframework.kafka.support.ExponentialBackOffWithMaxRetries;
import org.springframework.kafka.support.converter.ByteArrayJsonMessageConverter;
import org.springframework.kafka.support.converter.JsonMessageConverter;

@Configuration
public class KafkaConfig {
    @Bean
    public JsonMessageConverter jsonMessageConverter() {
        return new ByteArrayJsonMessageConverter();
    }

    @Bean
    public DefaultErrorHandler defaultErrorHandler(final KafkaOperations<Object, Object> kafkaOperations,
                                                   final KafkaProperties properties) {
        final var recoverer = new DeadLetterPublishingRecoverer(kafkaOperations,
                (consumerRecord, exception) -> new TopicPartition("%s-dlt".formatted(consumerRecord.topic()), 0)
        );
        final var backoff = new ExponentialBackOffWithMaxRetries(3);
        backoff.setInitialInterval(2000L);
        backoff.setMultiplier(5);
        return new DefaultErrorHandler(recoverer, backoff);
    }
}
