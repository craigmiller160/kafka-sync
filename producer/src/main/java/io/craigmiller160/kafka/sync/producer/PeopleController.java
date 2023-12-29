package io.craigmiller160.kafka.sync.producer;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/producer/people")
@RequiredArgsConstructor
public class PeopleController {
    private final Database database;
    private final KafkaTemplate<String,Person> kafkaTemplate;

    @PostMapping
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void addPerson(@RequestBody final Person person) {
        database.addPerson(person);
        kafkaTemplate.send("person-topic", person);
    }

    @GetMapping
    public List<Person> getPeople() {
        return database.getPeople();
    }
}
