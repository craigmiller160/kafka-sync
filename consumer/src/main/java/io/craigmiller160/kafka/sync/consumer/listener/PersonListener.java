package io.craigmiller160.kafka.sync.consumer.listener;

import io.craigmiller160.kafka.sync.consumer.database.Database;
import io.craigmiller160.kafka.sync.consumer.dto.Person;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.RetryableTopic;
import org.springframework.retry.annotation.Backoff;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class PersonListener {
    private final Database database;

    @RetryableTopic(
            attempts = "4",
            backoff = @Backoff(
                    delay = 2000L,
                    multiplier = 2.0
            ),
            autoCreateTopics = "false"
    )
    @KafkaListener(
            topics = "person-topic",
            groupId = "person-topic-group"
    )
    public void addPerson(final Person person) {
        log.info("Received person {}", person);
        if ("Die".equals(person.firstName())) {
            throw new RuntimeException("Dying");
        }
        database.addPerson(person);
    }
}
