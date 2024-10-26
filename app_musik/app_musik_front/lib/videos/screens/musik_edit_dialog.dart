import 'package:app_musik_front/videos/models/musik.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class MusicEditDialog extends StatelessWidget {
  final Music music;

  MusicEditDialog({super.key, required this.music});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialiser les contrôleurs avec les valeurs actuelles
    titleController.text = music.title;
    artistController.text = music.artist;
    albumController.text = music.album;
    genreController.text = music.genre;
    durationController.text = music.duration.toString();

    return AlertDialog(
      backgroundColor: const Color(0xFF2A2A3E),
      title: const Text(
        'Modifier la musique',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(
                labelText: 'Artiste',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: albumController,
              decoration: const InputDecoration(
                labelText: 'Album',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: genreController,
              decoration: const InputDecoration(
                labelText: 'Genre',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Durée (en secondes)',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Ferme le dialogue
          },
          child: const Text(
            'Annuler',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            // Logique de mise à jour
            try {
              await _updateMusic(
                  music.file, // Identifier la musique à modifier
                  titleController.text,
                  artistController.text,
                  albumController.text,
                  genreController.text,
                  int.parse(durationController.text));
              Navigator.of(context).pop(); // Ferme le dialogue
            } catch (e) {
              // Gérer les erreurs d'édition
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF2A2A3E),
                    content: Text(
                      'Erreur : $e',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            }
          },
          child: const Text(
            'Modifier',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _updateMusic(String filePath, String title, String artist,
      String album, String genre, int duration) async {
    final response = await http.put(
        Uri.parse(
            'http://localhost:8081/api/music/$filePath'), // Remplacer par l'ID ou le chemin de la musique
        body: {
          'title': title,
          'artist': artist,
          'album': album,
          'genre': genre,
          'duration': duration.toString(),
        });

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour de la musique');
    }
  }
}
