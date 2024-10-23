package bj.highfiveuniversity.app_musik.controllers;

import bj.highfiveuniversity.app_musik.models.Music;
import bj.highfiveuniversity.app_musik.services.MusicService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
        return music != null ? ResponseEntity.ok(music) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Music> createMusic(@RequestBody Music music) {
        Music newMusic = musicService.save(music);
        return ResponseEntity.ok(newMusic);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Music> updateMusic(@PathVariable Long id, @RequestBody Music music) {
        Music updatedMusic = musicService.save(music);
        return ResponseEntity.ok(updatedMusic);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMusic(@PathVariable Long id) {
        musicService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

}
