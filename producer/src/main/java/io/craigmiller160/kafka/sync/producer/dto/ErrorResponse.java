package io.craigmiller160.kafka.sync.producer.dto;

public record ErrorResponse(
        int status,
        String message
) {}
