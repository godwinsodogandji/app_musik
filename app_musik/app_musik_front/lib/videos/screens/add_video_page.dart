import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_musik_front/videos/models/video.dart';
import 'package:app_musik_front/videos/video_service.dart';
import 'package:file_picker/file_picker.dart'; // Ajoutez cette ligne
import 'dart:io' show kIsWeb;

class AddVideoPage extends StatefulWidget {
  // ignore: use_super_parameters
  const AddVideoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _videoService = VideoService('http://localhost:8081/api/video');

  // Contrôleurs pour les champs de texte
  final TextEditingController titleController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String _resolution = '480p';
  String? _filePath; // Chemin du fichier sélectionné

  void _showAddVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A3E),
          title: const Text(
            'Ajouter une nouvelle vidéo',
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
                  controller: directorController,
                  decoration: const InputDecoration(
                    labelText: 'Réalisateur',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Ouvrir le sélecteur de fichiers
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.video, // Limiter à des fichiers vidéo
                    );

                    if (result != null) {
                      setState(() {
                        if (kIsWeb) {
                          _filePath = result.files.single.bytes.toString();
                        } else {
                          _filePath = result.files.single.path;
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Couleur du bouton
                  ),
                  child: Text(
                    _filePath != null
                        ? 'Fichier sélectionné : ${_filePath!.split('/').last}'
                        : 'Choisir un fichier vidéo',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _resolution,
                  decoration: const InputDecoration(
                    labelText: 'Résolution',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  dropdownColor: const Color(
                      0xFF2A2A3E), // Couleur de fond de la liste déroulante
                  items:
                      ['480p', '720p', '1080p', '4K'].map((String resolution) {
                    return DropdownMenuItem<String>(
                      value: resolution,
                      child: Text(resolution,
                          style: const TextStyle(
                              color: Colors.white)), // Couleur du texte
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _resolution = value!;
                    });
                  },
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
                // Vérifiez si tous les champs sont remplis
                if (titleController.text.isEmpty ||
                    directorController.text.isEmpty ||
                    genreController.text.isEmpty ||
                    durationController.text.isEmpty ||
                    _filePath == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Veuillez remplir tous les champs.')),
                  );
                  return;
                }

                Video newVideo = Video(
                  title: titleController.text,
                  director: directorController.text,
                  genre: genreController.text,
                  duration: int.parse(durationController.text),
                  file: _filePath!, // Utiliser le chemin du fichier sélectionné
                  resolution: _resolution,
                  createdAt: DateTime.now().toString(),
                  updatedAt: DateTime.now().toString(),
                );

                try {
                  await _videoService.createVideo(newVideo);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Ferme le dialogue
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Erreur lors de l\'ajout de la vidéo: $e')),
                  );
                }
              },
              child: const Text(
                'Ajouter la vidéo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une vidéo'),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.video),
            onPressed: () => _showAddVideoDialog(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Page d\'ajout de vidéo'),
      ),
    );
  }
}
