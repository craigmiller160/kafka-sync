package io.craigmiller160.kafka.sync.consumer.dto;

import lombok.Value;

import java.util.UUID;

@Value
public class Person {
    UUID id;
    String firstName;
    String lastName;
}
