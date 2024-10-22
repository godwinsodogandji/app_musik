package bj.highfiveuniversity.app_musik.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import bj.highfiveuniversity.app_musik.models.User;

public interface UserRepository extends JpaRepository<User, Long> {

}
