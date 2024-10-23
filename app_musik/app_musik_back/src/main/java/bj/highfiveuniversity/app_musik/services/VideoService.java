package bj.highfiveuniversity.app_musik.services;


import bj.highfiveuniversity.app_musik.models.Video;
import bj.highfiveuniversity.app_musik.repositories.VideoRepository;
import jakarta.transaction.Transactional;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.javafaker.Faker;


@Service
public class VideoService {
    @Autowired
    private VideoRepository videoRepository;

    private final Faker faker = new Faker();

    public List<Video> findAll() {
        return videoRepository.findAll();
    }

    public Video findById(Long id) {
        return videoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Aucune vidéo trouvée avec l'id " + id));
    }

    public Video save(Video video) {
        return videoRepository.save(video);
    }

    public Video update(Long id, Video video) {
        Video videoToUpdate = videoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vidéo avec l'id " + id + " non trouvée"));
        
        // Mise à jour des champs
        videoToUpdate.setTitle(video.getTitle());
        videoToUpdate.setDirector(video.getDirector());
        videoToUpdate.setGenre(video.getGenre());
        videoToUpdate.setDuration(video.getDuration());
        videoToUpdate.setFile(video.getFile());
        videoToUpdate.setResolution(video.getResolution());
        
        return videoRepository.save(videoToUpdate);
    }

    public void deleteById(Long id) {
        videoRepository.deleteById(id);
    }

    @Transactional
    public void generateFakeVideos(int count) {
        for (int i = 0; i < count; i++) {
            Video video = new Video();
            video.setTitle(faker.book().title());
            video.setDirector(faker.name().fullName());
            video.setGenre(faker.book().genre());
            video.setDuration(faker.number().numberBetween(60, 360)); // Durée en secondes
            video.setFile(faker.file().fileName());
            video.setResolution(faker.options().option("480p", "720p", "1080p", "4K"));

            videoRepository.save(video);
        }
    }
}
