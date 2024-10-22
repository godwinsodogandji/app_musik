package bj.highfiveuniversity.app_musik.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bj.highfiveuniversity.app_musik.models.User;
import bj.highfiveuniversity.app_musik.repositories.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("aucun utilisateur trouvé"));
        return user;
    }

    public User createUser(User user) {
        User newUser = userRepository.save(user);
        return newUser;
    }

    public User updateUser(Long id, User user) {
        User updateUser = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User avec l'id " + id + " non trouvé"));
        updateUser.setUsername(user.getUsername());
        updateUser.setEmail(user.getEmail());
        updateUser.setPassword(user.getPassword());
        return updateUser;

    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

}
