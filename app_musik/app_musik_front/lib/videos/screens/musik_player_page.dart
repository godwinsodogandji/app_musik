import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerPage extends StatefulWidget {
  final String title;
  final String artist;
  final String audioFile; // Utilisé pour le chemin vers le fichier audio

  const MusicPlayerPage({
    super.key,
    required this.title,
    required this.artist,
    required this.audioFile, // Reçoit le fichier audio
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer; // Déclare le lecteur audio
  bool isPlaying = false; // Gère l'état de lecture

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialise le lecteur
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libère les ressources
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (isPlaying) {
        _audioPlayer.pause(); // Pause la musique
      } else {
        await _audioPlayer.setAsset(
           "../../../assets/Sunny Fruit - Beat Blitz.mp3"); // Charge le fichier audio à partir des assets
        _audioPlayer.play(); // Joue la musique
      }
      setState(() {
        isPlaying = !isPlaying; // Met à jour l'état de lecture
      });
    } catch (e) {
      // Gère les erreurs de lecture
      print('Erreur de lecture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retourne à la page précédente
          },
        ),
        title: const Text('Now Playing'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF162447),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Couverture de l'album
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    // Utilisation de Image.asset pour charger l'image
                    'assets/vector-music-melody-note-dancing-flow/musbackround1_12.jpg',
                    height: 250,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.artist,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              const Icon(
                FontAwesomeIcons.music,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.backward,
                        color: Colors.white),
                    onPressed: () {
                      // Logique pour revenir à la piste précédente
                    },
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed:
                        _togglePlayPause, // Appelle la méthode de lecture/pause
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isPlaying
                          ? 'Pause'
                          : 'Play', // Change le texte selon l'état
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.forward,
                        color: Colors.white),
                    onPressed: () {
                      // Logique pour passer à la prochaine piste
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
