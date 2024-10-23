package bj.highfiveuniversity.app_musik.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.javafaker.Faker;

import bj.highfiveuniversity.app_musik.models.Music;
import bj.highfiveuniversity.app_musik.repositories.MusicRepository;
import jakarta.transaction.Transactional;

@Service
public class MusicService {
    @Autowired
    private MusicRepository musicRepository;

    private final Faker faker = new Faker();

    public List<Music> findAll() {
        return musicRepository.findAll();
    }

    public Music findById(Long id) {
        return musicRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Aucune musique trouvée avec l'id " + id));
    }

    public Music save(Music music) {
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
        musicToUpdate.setFile(music.getFile());
        
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
