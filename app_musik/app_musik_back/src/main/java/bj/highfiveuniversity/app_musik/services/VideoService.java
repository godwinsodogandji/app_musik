package bj.highfiveuniversity.app_musik.services;

import bj.highfiveuniversity.app_musik.models.Video;
import bj.highfiveuniversity.app_musik.repositories.VideoRepository;
import jakarta.transaction.Transactional;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.github.javafaker.Faker;

@Service
public class VideoService {
    @Autowired
    private VideoRepository videoRepository;

    private final Faker faker = new Faker();
    private final String uploadDir = "C:\\Users\\godwin.sodogandji\\Documents\\dev\\app_musik\\uploads"; // Répertoire
                                                                                                         // de
                                                                                                         // sauvegarde

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
            video.setResolution(faker.options().option("480p", "720p", "1080p", "4K"));

            videoRepository.save(video);
        }
    }

    public String saveFile(MultipartFile file) {
        try {
            // Créer le répertoire s'il n'existe pas
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
    
            // Enregistrer le fichier
            Path path = Paths.get(uploadDir + File.separator + file.getOriginalFilename());
            Files.copy(file.getInputStream(), path);
    
            return file.getOriginalFilename(); // Retournez le nom du fichier enregistré
        } catch (IOException e) {
            e.printStackTrace(); 
            return null; // Gérer l'erreur de manière appropriée
        }
    }
    
}
