package bj.highfiveuniversity.app_musik.services;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bj.highfiveuniversity.app_musik.models.Video;
import bj.highfiveuniversity.app_musik.repositories.VideoRepository;

@Service
public class VideoService {
    @Autowired
    private VideoRepository videoRepository;

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
}
