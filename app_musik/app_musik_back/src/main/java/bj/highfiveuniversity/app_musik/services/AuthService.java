package bj.highfiveuniversity.app_musik.services;

import bj.highfiveuniversity.app_musik.models.User;
import bj.highfiveuniversity.app_musik.models.AuthResponse;
import bj.highfiveuniversity.app_musik.repositories.UserRepository;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public ResponseEntity<?> register(User user) {
        // Hachage du mot de passe avant de le stocker
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        return ResponseEntity.ok("User registered successfully!");
    }

    public ResponseEntity<?> login(User user) {
        Optional<User> existingUserOptional = userRepository.findByUsername(user.getUsername());

        if (existingUserOptional.isPresent()) {

            User existingUser = existingUserOptional.get();

            // Déballage de l'utilisateur
            if (passwordEncoder.matches(user.getPassword(), existingUser.getPassword())) {
                String token = jwtService.generateToken(existingUser.getUsername());
                return ResponseEntity.ok(new AuthResponse(token)); // Retournez le token
            }
        }

        return ResponseEntity.status(401).body("Invalid username or password");
    }

}
