package io.craigmiller160.kafka.sync.consumer.controller;

import io.craigmiller160.kafka.sync.consumer.database.Database;
import io.craigmiller160.kafka.sync.consumer.dto.Person;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/consumer/people")
@RequiredArgsConstructor
public class PeopleController {
    private final Database database;

    @GetMapping
    public List<Person> getPeople() {
        log.info("Getting people");
        return database.getPeople();
    }
}
