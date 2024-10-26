package bj.highfiveuniversity.app_musik.controllers;

import bj.highfiveuniversity.app_musik.models.Video;
import bj.highfiveuniversity.app_musik.services.VideoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/video")
public class VideoController {

    @Autowired
    private VideoService videoService;

    @GetMapping
    public List<Video> getAllVideos() {
        return videoService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Video> getVideoById(@PathVariable Long id) {
        Video video = videoService.findById(id);
        return video != null ? ResponseEntity.ok(video) : ResponseEntity.notFound().build();
    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<Video> createVideo(
            @RequestParam("title") String title,
            @RequestParam("director") String director,
            @RequestParam("genre") String genre,
            @RequestParam("duration") int duration,
            @RequestParam("resolution") String resolution,
            @RequestParam("file") MultipartFile file) {

        Video newVideo = new Video();
        newVideo.setTitle(title);
        newVideo.setDirector(director);
        newVideo.setGenre(genre);
        newVideo.setDuration(duration);
        newVideo.setResolution(resolution);

        String filePath = videoService.saveFile(file);
        if (filePath == null) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null); // Vous pourriez aussi retourner un message d'erreur spécifique ici
        }
        newVideo.setFile(filePath);

        Video savedVideo = videoService.save(newVideo);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedVideo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Video> updateVideo(@PathVariable Long id, @Valid @RequestBody Video video) {
        Video updatedVideo = videoService.update(id, video);
        return ResponseEntity.ok(updatedVideo);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVideo(@PathVariable Long id) {
        videoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/generate-videos")
    public ResponseEntity<String> generateVideos(@RequestParam int count) {
        videoService.generateFakeVideos(count);
        return ResponseEntity.ok(count + " vidéos fictives générées.");
    }
}
