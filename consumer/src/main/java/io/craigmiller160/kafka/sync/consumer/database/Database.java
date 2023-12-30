package io.craigmiller160.kafka.sync.consumer.database;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.craigmiller160.kafka.sync.consumer.dto.Person;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileInputStream;
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
    @PostConstruct
    public synchronized void loadDataIfExists() {
        if (DATABASE_FILE.exists()) {
            final JavaType peopleListType = objectMapper.getTypeFactory().constructCollectionType(List.class, Person.class);
            try (final var inputStream = new FileInputStream(DATABASE_FILE)) {
                final List<Person> fileData = objectMapper.readValue(inputStream, peopleListType);
                people.clear();
                people.addAll(fileData);
            }
        }
    }

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
