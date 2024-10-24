package bj.highfiveuniversity.app_musik.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.javafaker.Faker;

import bj.highfiveuniversity.app_musik.models.Video;
import bj.highfiveuniversity.app_musik.repositories.VideoRepository;
import jakarta.annotation.PostConstruct;

@Service
public class VideoSeederService {

    @Autowired
    private VideoRepository videoRepository;

    private final Faker faker = new Faker();

    @PostConstruct
    public void seedDatabase() {
        List<Video> videos = videoRepository.findAll();
        if (videos.isEmpty()) {
            List<Video> seededVideos = IntStream.range(0, 10)
                    .mapToObj(this::createVideo)
                    .collect(Collectors.toList());

            videoRepository.saveAll(seededVideos);
            System.out.println("Database seeded with initial video records.");
        } else {
            System.out.println("Database already seeded with video records.");
        }
    }

    private Video createVideo(int index) {
        Video video = new Video();
        video.setTitle(faker.book().title()); // Utilisez le titre d'un livre comme exemple
        video.setDirector(faker.name().fullName()); // Nom aléatoire pour le directeur
        video.setGenre(faker.music().genre()); // Utilisez un genre de musique comme exemple
        video.setDuration(faker.number().numberBetween(60, 300)); // Durée entre 1 et 5 minutes
        video.setFile(faker.file().fileName()); // Nom de fichier aléatoire
        video.setResolution(faker.options().option("480p", "720p", "1080p", "4K")); // Résolution aléatoire
        video.setCreatedAt(LocalDateTime.now());
        video.setUpdatedAt(LocalDateTime.now());
        return video;
    }
}
