package bj.highfiveuniversity.app_musik.services;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.github.javafaker.Faker;

import bj.highfiveuniversity.app_musik.models.Music;
import bj.highfiveuniversity.app_musik.repositories.MusicRepository;
import jakarta.transaction.Transactional;

@Service
public class MusicService {
    @Autowired
    private MusicRepository musicRepository;

    private final Faker faker = new Faker();
    private final String uploadDir = "C:\\Users\\godwin.sodogandji\\Documents\\dev\\app_musik\\app_musik\\app_musik_back\\src\\main\\upload"; // Spécifiez le répertoire où les fichiers seront sauvegardés

    public List<Music> findAll() {
        return musicRepository.findAll();
    }

    public Music findById(Long id) {
        return musicRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Aucune musique trouvée avec l'id " + id));
    }

    public Music save(Music music, MultipartFile file) {
        if (file != null && !file.isEmpty()) {
            try {
                // Vérifiez si le répertoire existe, sinon créez-le
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                // Créer un nom de fichier unique si le fichier existe déjà
                String originalFilename = file.getOriginalFilename();
                Path targetLocation = uploadPath.resolve(originalFilename);
                int count = 1;
                while (Files.exists(targetLocation)) {
                    String newFilename = originalFilename + "(" + count + ")";
                    targetLocation = uploadPath.resolve(newFilename);
                    count++;
                }

                // Sauvegarde du fichier
                Files.copy(file.getInputStream(), targetLocation);
                music.setFile(targetLocation.getFileName().toString());
                
                // Log pour le débogage
                System.out.println("Fichier sauvegardé à : " + targetLocation.toString());
            } catch (IOException e) {
                throw new RuntimeException("Erreur lors de la sauvegarde du fichier: " + e.getMessage());
            }
        }
        return musicRepository.save(music);
    }

    public Music update(Long id, Music music) {
        Music musicToUpdate = musicRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Musique avec l'id " + id + " non trouvée"));

        // Mise à jour des champs
        musicToUpdate.setTitle(music.getTitle());
        musicToUpdate.setArtist(music.getArtist());
        musicToUpdate.setAlbum(music.getAlbum());
        musicToUpdate.setGenre(music.getGenre());
        musicToUpdate.setDuration(music.getDuration());

        // Si vous souhaitez changer le fichier lors de la mise à jour
        if (music.getFile() != null) {
            musicToUpdate.setFile(music.getFile());
        }

        return musicRepository.save(musicToUpdate);
    }

    public void deleteById(Long id) {
        musicRepository.deleteById(id);
    }

    @Transactional
    public void generateFakeMusicData(int count) {
        for (int i = 0; i < count; i++) {
            Music music = Music.builder()
                .title(faker.lorem().sentence(3))
                .artist(faker.book().author())
                .album(faker.lorem().word() + " Album")
                .genre(faker.music().genre())
                .duration(faker.number().numberBetween(180, 300)) // Durée en secondes
                .file(faker.file().fileName())
                .build();

            musicRepository.save(music);
        }
    }
}