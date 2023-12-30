package io.craigmiller160.kafka.sync.consumer.listener;

import io.craigmiller160.kafka.sync.consumer.database.Database;
import io.craigmiller160.kafka.sync.consumer.dto.Person;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class PersonListener {
    private final Database database;

    @KafkaListener(topics = "person-topic", groupId = "person-topic-group")
    public void addPerson(final Person person) {
        log.info("Received person {}", person);
        database.addPerson(person);
    }
}
