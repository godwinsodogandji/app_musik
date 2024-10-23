package bj.highfiveuniversity.app_musik.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import bj.highfiveuniversity.app_musik.models.Music;

@Repository
public interface MusicRepository extends JpaRepository<Music, Long> {
   
}
