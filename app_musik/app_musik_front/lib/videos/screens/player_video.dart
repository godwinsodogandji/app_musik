import 'package:flutter/material.dart';

class PlayVideoPage extends StatefulWidget {
  final String title;
  final String artist;

  const PlayVideoPage({super.key, required this.title, required this.artist});

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  bool isPlaying = false; // Booléen pour gérer l'état de lecture

  // Fonction pour gérer la lecture/pause
  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      // Démarrer la vidéo
      print('Lecture de la vidéo');
      // Logique pour démarrer la lecture
    } else {
      // Mettre en pause la vidéo
      print('Pause de la vidéo');
      // Logique pour mettre en pause
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 210, 210, 230),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF0D0D1E),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoThumbnail(),
            const SizedBox(height: 30),
            _buildVideoDetails(),
            const SizedBox(height: 30),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  // Widget pour l'image miniature de la vidéo
  Widget _buildVideoThumbnail() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image: AssetImage(
                '../../../assets/realistic-world-music-day-background-with-instruments/7244594.jpg'), // Exemple d'image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Widget pour afficher les détails de la vidéo
  Widget _buildVideoDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Now Playing',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Artist: ${widget.artist}',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  // Widget pour les boutons de contrôle (Play, Pause, etc.)
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white),
          onPressed: () {
            // Action pour reculer de 10 secondes
          },
        ),
        const SizedBox(width: 30),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying
                  ? Icons.pause
                  : Icons.play_arrow, // Changer l'icône selon l'état
              color: Colors.white,
            ),
            iconSize: 40,
            onPressed:
                _togglePlayPause, // Appel de la fonction pour gérer Play/Pause
          ),
        ),
        const SizedBox(width: 30),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white),
          onPressed: () {
            // Action pour avancer de 10 secondes
          },
        ),
      ],
    );
  }
}
