package io.craigmiller160.kafka.sync.consumer.listener;

import io.craigmiller160.kafka.sync.consumer.dto.Person;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class PersonListener {
    @KafkaListener(topics = "person-topic")
    public void addPerson(final Person person) {
        log.info("Received person {}", person);
    }
}
