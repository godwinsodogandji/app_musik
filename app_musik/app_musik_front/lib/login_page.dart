import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8081/api/auth/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': _usernameController.text,
            'password': _passwordController.text,
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Login successful: ${responseData['token']}');
          // Vider les champs après une connexion réussie
          _usernameController.clear();
          _passwordController.clear();
        } else {
          final errorData = jsonDecode(response.body);
          print(
              'Login failed: ${response.reasonPhrase}, Details: ${errorData['message']}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      '../assets/beautiful-musical-notes-wave-background-design/11415.jpg'), // Remplacez par votre chemin d'image
                  fit: BoxFit.cover // Pour couvrir tout l'écran
                  ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 500, // Augmentez la largeur de la carte
                height: 500, // Ajoutez une hauteur fixe si nécessaire
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.8), // Couleur de fond blanche avec opacité
                  borderRadius: BorderRadius.circular(15), // Arrondir les coins
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 104, 103, 103)
                          .withOpacity(0.4),
                      spreadRadius: 6,
                      blurRadius: 10,
                      offset: const Offset(
                          0, 3), // Changez la position de l'ombre si nécessaire
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20), // Ajoutez un padding interne
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 70),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(176, 21, 21, 21),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _usernameController,
                          decoration:
                              const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person,  color: Colors.grey)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10), // Espace entre les champs
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password',  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 235, 226, 248),
                                minimumSize: const Size(
                                    150, 50), // Augmentez la taille du bouton
                                textStyle: const TextStyle(
                                    fontSize:
                                        18), // Taille du texte plus grande
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    color: Color.fromARGB(255, 129, 128, 128)),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
