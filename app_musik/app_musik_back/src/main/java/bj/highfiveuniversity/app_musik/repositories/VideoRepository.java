package bj.highfiveuniversity.app_musik.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import bj.highfiveuniversity.app_musik.models.Video;

public interface VideoRepository extends JpaRepository<Video, Long> {
    
}
