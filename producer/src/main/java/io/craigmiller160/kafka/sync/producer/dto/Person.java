package io.craigmiller160.kafka.sync.producer.dto;

import java.util.UUID;

public record Person(UUID id, String firstName, String lastName) {}
