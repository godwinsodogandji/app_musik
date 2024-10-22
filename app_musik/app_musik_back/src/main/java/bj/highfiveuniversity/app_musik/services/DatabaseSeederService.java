package bj.highfiveuniversity.app_musik.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.javafaker.Faker;

import bj.highfiveuniversity.app_musik.models.User;
import bj.highfiveuniversity.app_musik.repositories.UserRepository;
import jakarta.annotation.PostConstruct;

@Service
public class DatabaseSeederService {
    
    @Autowired
    private UserRepository userRepository;

    private final Faker faker = new Faker();

    @PostConstruct
    public void seedDatabase() {
        List<User> users = userRepository.findAll();
        if (users.isEmpty()) {
            List<User> seededUsers = IntStream.range(0, 10)
                    .mapToObj(this::createUser)
                    .collect(Collectors.toList());

            userRepository.saveAll(seededUsers);
            System.out.println("Database seeded with initial users.");
        } else {
            System.out.println("Database already seeded.");
        }
    }

    private User createUser(int index) {
        User user = new User();
        user.setUsername(faker.name().username());
        user.setPassword("password" + index); // Vous devriez utiliser un système d'authentification sécurisé en production
        user.setEmail(faker.internet().emailAddress());
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return user;
    }
}
