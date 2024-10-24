package bj.highfiveuniversity.app_musik.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.javafaker.Faker;

import bj.highfiveuniversity.app_musik.models.Music;
import bj.highfiveuniversity.app_musik.repositories.MusicRepository;
import jakarta.annotation.PostConstruct;

@Service
public class MusicSeederService {
    
    @Autowired
    private MusicRepository musicRepository;

    private final Faker faker = new Faker();

    @PostConstruct
    public void seedDatabase() {
        List<Music> musicList = musicRepository.findAll();
        if (musicList.isEmpty()) {
            List<Music> seededMusic = IntStream.range(0, 10)
                    .mapToObj(this::createMusic)
                    .collect(Collectors.toList());

            musicRepository.saveAll(seededMusic);
            System.out.println("Database seeded with initial music records.");
        } else {
            System.out.println("Database already seeded with music records.");
        }
    }

    private Music createMusic(int index) {
        Music music = new Music();
        music.setTitle(faker.music().toString());
        music.setArtist(faker.music().instrument());
        music.setAlbum(faker.music().genre());
        music.setGenre(faker.music().genre());
        music.setDuration(faker.number().numberBetween(120, 300)); // Durée en secondes
        music.setFile(faker.file().fileName());
        music.setCreatedAt(LocalDateTime.now());
        music.setUpdatedAt(LocalDateTime.now());
        return music;
    }
}
