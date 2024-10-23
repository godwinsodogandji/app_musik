package bj.highfiveuniversity.app_musik.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import bj.highfiveuniversity.app_musik.models.Playlist;

public interface PlaylistRepository extends JpaRepository<Playlist, Long>{
    
}
