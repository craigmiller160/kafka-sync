package io.craigmiller160.kafka.sync.consumer.dto;

public record ErrorResponse(
        int status,
        String message
) {}
