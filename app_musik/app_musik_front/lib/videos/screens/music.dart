// ignore_for_file: use_build_context_synchronously

import 'package:app_musik_front/videos/screens/musik_player_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert'; // Nécessaire pour jsonDecode
import 'package:http/http.dart' as http; // Utilisé pour les requêtes HTTP
import 'package:file_picker/file_picker.dart'; // Ajouté pour le choix de fichiers
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 239, 239, 242),
      ),
      body: const AlbumScreen(), // Insertion de l'AlbumScreen
    );
  }
}

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final String apiUrl =
      'http://localhost:8081/api/music'; // URL de l'API de musique
  late Future<List<Music>> musicsFuture;

  @override
  void initState() {
    super.initState();
    musicsFuture = fetchMusics(); // Initialiser la liste des musiques
  }

  Future<List<Music>> fetchMusics() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Si la requête est réussie, décode la réponse JSON
      final List<dynamic> musicData = jsonDecode(response.body);
      return musicData.map((json) => Music.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des musiques');
    }
  }

  Future<void> _addMusic(
      String title,
      String artist,
      String album,
      String genre,
      int duration,
      String? filePath,
      Uint8List? fileBytes) async {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.fields['title'] = title;
    request.fields['artist'] = artist;
    request.fields['album'] = album;
    request.fields['genre'] = genre;
    request.fields['duration'] = duration.toString();

    if (filePath != null && filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    } else if (fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes,
          filename: 'music_file.mp3'));
    } else {
      throw Exception('Aucun fichier sélectionné');
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        Fluttertoast.showToast(
          msg: "Musique ajoutée avec succès !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Rafraîchir la liste des musiques après l'ajout
        setState(() {
          musicsFuture =
              fetchMusics(); // Met à jour le future pour le FutureBuilder
        });
      } else {
        throw Exception('Erreur lors de l\'ajout de la musique');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la musique : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('../assets/wavy-wallpaper-concept/3526699.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder<List<Music>>(
        future: musicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune musique disponible'));
          } else {
            List<Music> musics = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Couverture de l'album
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          '../../../assets/134af8d4e28e7d0bb3355a8944749f0f.jpg',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Album',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                            Text('17',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold)),
                            Text('LYRIC SERIES',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text('Choose 17 songs for you',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Section des actions CRUD
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.plus,
                              color: Colors.white),
                          tooltip: 'Ajouter une nouvelle musique',
                          onPressed: () {
                            _showAddMusicDialog(context);
                          },
                        ),
                        IconButton(
                          // ignore: deprecated_member_use
                          icon: const Icon(FontAwesomeIcons.edit,
                              color: Colors.white),
                          tooltip: 'Modifier',
                          onPressed: () {
                            // Logique de modification
                            print('Modifier une musique');
                          },
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.trash,
                              color: Colors.white),
                          tooltip: 'Supprimer',
                          onPressed: () {
                            // Logique de suppression
                            print('Supprimer une musique');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Section Play All et liste des musiques récupérées depuis l'API
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('PLAY ALL',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: musics.map((music) {
                        return PlaylistItem(
                          title: music.title,
                          artist: music.artist,
                          file: music.file, // Passer le fichier audio
                          onTap: () {
                            // Naviguer vers la page du lecteur de musique
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicPlayerPage(
                                  // Passez la liste des musiques
                                  title: music.title,
                                  artist: music.artist,
                                  audioFile: music.file,
                                  musics:
                                      musics, // Passez l'index de la musique actuelle
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Méthode pour afficher le modal d'ajout de musique
  void _showAddMusicDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController artistController = TextEditingController();
    final TextEditingController albumController = TextEditingController();
    final TextEditingController genreController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    String?
        selectedFile; // Variable pour stocker le chemin du fichier sélectionné
    Uint8List?
        selectedFileBytes; // Variable pour stocker les bytes du fichier sélectionné

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A3E),
          title: const Text(
            'Ajouter une nouvelle musique',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Ouvrir le sélecteur de fichiers
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      if (kIsWeb) {
                        selectedFileBytes = result.files.single.bytes;
                      } else {
                        selectedFile = result.files.single.path;
                      }
                    }
                  },
                  child: const Text('Choisir un fichier'),
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

                // Ajout de la musique
                try {
                  await _addMusic(
                    titleController.text,
                    artistController.text,
                    albumController.text,
                    genreController.text,
                    int.parse(durationController.text),
                    selectedFile,
                    selectedFileBytes,
                  );
                  Navigator.of(context).pop(); // Ferme le dialogue
                } catch (e) {
                  // Affichage d'une alerte en cas d'erreur d'ajout
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
                'Ajouter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Modèle de données pour la musique
class Music {
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int duration;
  final String file;

  Music({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.duration,
    required this.file,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      genre: json['genre'],
      duration: json['duration'],
      file: json['file'],
    );
  }
}

// Widget pour afficher un élément de la liste de lecture
class PlaylistItem extends StatelessWidget {
  final String title;
  final String artist;
  final String file;
  final VoidCallback onTap;

  const PlaylistItem({
    super.key,
    required this.title,
    required this.artist,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(color: Color.fromARGB(255, 18, 17, 17))),
      subtitle: Text(artist, style: const TextStyle(color: Colors.grey)),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}
