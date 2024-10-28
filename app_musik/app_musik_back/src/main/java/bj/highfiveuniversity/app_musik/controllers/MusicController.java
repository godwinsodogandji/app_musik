package bj.highfiveuniversity.app_musik.controllers;

import bj.highfiveuniversity.app_musik.models.Music;
import bj.highfiveuniversity.app_musik.services.MusicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/music")
public class MusicController {

    @Autowired
    private MusicService musicService;

    @GetMapping
    public List<Music> getAllMusic() {
        return musicService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Music> getMusicById(@PathVariable Long id) {
        Music music = musicService.findById(id);
        return ResponseEntity.ok(music);
    }

    @PostMapping
    public ResponseEntity<Music> createMusic(
            @RequestParam("title") String title,
            @RequestParam("artist") String artist,
            @RequestParam("album") String album,
            @RequestParam("genre") String genre,
            @RequestParam("duration") int duration,
            @RequestParam("file") MultipartFile file) {
        
        Music music = new Music();
        music.setTitle(title);
        music.setArtist(artist);
        music.setAlbum(album);
        music.setGenre(genre);
        music.setDuration(duration);
        
        Music createdMusic = musicService.save(music, file);
        return ResponseEntity.status(201).body(createdMusic);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Music> updateMusic(@PathVariable Long id, @RequestBody Music music) {
        Music updatedMusic = musicService.update(id, music);
        return ResponseEntity.ok(updatedMusic);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMusic(@PathVariable Long id) {
        musicService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    // Nouveau endpoint pour obtenir le fichier audio par son ID
    @GetMapping("/audio/{id}")
    public ResponseEntity<byte[]> getAudioFile(@PathVariable Long id) {
        byte[] audioData = musicService.getAudioFileById(id); // Récupère les données binaires du fichier audio

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM); // Définit le type de contenu binaire
        headers.setContentDispositionFormData("attachment", "music.mp3"); // Nom du fichier

        return new ResponseEntity<>(audioData, headers, HttpStatus.OK);
    }
}