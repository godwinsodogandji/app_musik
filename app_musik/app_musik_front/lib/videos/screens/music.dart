import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert'; // Nécessaire pour jsonDecode
import 'package:http/http.dart' as http; // Utilisé pour les requêtes HTTP

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music'),
      ),
      body: const AlbumScreen(), // Insertion de l'AlbumScreen
    );
  }
}

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  // Instancie le service de musique
  final String apiUrl =
      'http://localhost:8081/api/music'; // URL de ton API de musique

  Future<List<Music>> fetchMusics() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Si la requête est réussie, décode la réponse JSON
      final List<dynamic> musicData = jsonDecode(response.body);
      return musicData.map((json) => Music.fromJson(json)).toList();
    } else {
      // En cas d'échec de la requête, lance une exception
      throw Exception('Erreur lors du chargement des musiques');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: FutureBuilder<List<Music>>(
        future: fetchMusics(),
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
                      Image.network(
                        '../../../assets/134af8d4e28e7d0bb3355a8944749f0f.jpg',
                        height: 200,
                        fit: BoxFit.cover,
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

                  // Section des statistiques
                  Container(
                    color: const Color(0xFF2A2A3E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StatsItem(icon: FontAwesomeIcons.heart, count: '1,207'),
                        StatsItem(icon: FontAwesomeIcons.comment, count: '188'),
                        StatsItem(icon: FontAwesomeIcons.share, count: '1,339'),
                        StatsItem(icon: FontAwesomeIcons.star, count: '2,008'),
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
                            title: music.title, artist: music.artist);
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
}

class StatsItem extends StatelessWidget {
  final IconData icon;
  final String count;

  const StatsItem({super.key, required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final String title;
  final String artist;

  const PlaylistItem({super.key, required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text(artist,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          const Icon(FontAwesomeIcons.play, color: Colors.white),
        ],
      ),
    );
  }
}

// Modèle Music
class Music {
  final String title;
  final String artist;

  Music({required this.title, required this.artist});

  // Méthode de création d'une instance Music à partir du JSON
  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'],
      artist: json['artist'],
    );
  }
}
