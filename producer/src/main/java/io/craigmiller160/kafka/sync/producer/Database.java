package io.craigmiller160.kafka.sync.producer;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
public class Database {
    private static final File DATABASE_FILE = Paths.get(System.getProperty("user.dir"), "database.json").toFile();
    private final ObjectMapper objectMapper;
    private final List<Person> people = new ArrayList<>();

    @SneakyThrows
    public synchronized void addPerson(final Person person) {
        people.add(person);
        try(final var outputStream = new FileOutputStream(DATABASE_FILE)) {
            objectMapper.writerWithDefaultPrettyPrinter()
                    .writeValue(outputStream, people);
        }
    }

    public synchronized List<Person> getPeople() {
        return people;
    }
}
