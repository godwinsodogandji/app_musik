package bj.highfiveuniversity.app_musik.services;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bj.highfiveuniversity.app_musik.models.Playlist;
import bj.highfiveuniversity.app_musik.repositories.PlaylistRepository;

@Service
public class PlaylistService {
    @Autowired
    private PlaylistRepository playlistRepository;

    public List<Playlist> findAll() {
        return playlistRepository.findAll();
    }

    public Playlist findById(Long id) {
        return playlistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Aucune playlist trouvée avec l'id " + id));
    }

    public Playlist save(Playlist playlist) {
        if (playlist.getUser() == null) {
            throw new RuntimeException("L'utilisateur doit être spécifié.");
        }
        return playlistRepository.save(playlist);
    }

    public Playlist update(Long id, Playlist playlist) {
        Playlist playlistToUpdate = playlistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Playlist avec l'id " + id + " non trouvée"));
        
        // Mise à jour des champs
        playlistToUpdate.setName(playlist.getName());
        playlistToUpdate.setMusics(playlist.getMusics());
        
        return playlistRepository.save(playlistToUpdate);
    }

    public void deleteById(Long id) {
        playlistRepository.deleteById(id);
    }
}
