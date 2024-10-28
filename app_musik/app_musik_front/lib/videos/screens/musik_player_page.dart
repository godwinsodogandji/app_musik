import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_musik_front/videos/screens/music.dart';

class MusicPlayerPage extends StatefulWidget {
  final List<Music> musics; // Liste de musiques
  final int initialIndex; // Index de la musique initiale

  const MusicPlayerPage({
    super.key,
    required this.musics,
    this.initialIndex = 0,
    required String title,
    required String artist,
    required String audioFile, // Par défaut, lecture de la première musique
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer; // Déclare le lecteur audio
  bool isPlaying = false; // Gère l'état de lecture
  int currentIndex = 0; // Index de la piste actuelle
  Duration _currentPosition = Duration.zero; // Position actuelle de la musique
  Duration _totalDuration = Duration.zero; // Durée totale de la musique

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialise le lecteur
    currentIndex = widget.initialIndex; // Définit l'index initial

    // S'abonner aux streams pour la position et la durée
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });

    // Charger la première piste
    _loadMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libère les ressources
    super.dispose();
  }

  Future<void> _loadMusic() async {
    try {
      // Charge la piste actuelle
      await _audioPlayer
          .setAsset('../../../assets/Sunny Fruit - Beat Blitz.mp3');
      _audioPlayer
          .play(); // Joue automatiquement la musique après le chargement
      setState(() {
        isPlaying = true; // Met à jour l'état de lecture
      });
    } catch (e) {
      print('Erreur de lecture: $e');
    }
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      _audioPlayer.pause(); // Pause la musique
    } else {
      _audioPlayer.play(); // Joue la musique
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  // Passe à la piste suivante
  void _nextTrack() async {
    if (currentIndex < widget.musics.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _loadMusic();
    }
  }

  // Revient à la piste précédente
  void _previousTrack() async {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      await _loadMusic();
    }
  }

  void _seekToPosition(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position); // Change la position de la musique
  }

  @override
  Widget build(BuildContext context) {
    final currentMusic = widget.musics[currentIndex];

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
          image: DecorationImage(
            image: AssetImage(
                '../../../assets/abstract-moon-start-lights.jpg'), // Chemin de ton image
            fit:
                BoxFit.cover, // Ajuste l'image pour qu'elle couvre tout l'écran
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
                    'assets/vector-music-melody-note-dancing-flow/musbackround1_12.jpg', // Image de couverture
                    height: 250,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentMusic.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                currentMusic.artist,
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
              // Barre de progression
              Slider(
                value: _currentPosition.inSeconds.toDouble(),
                min: 0.0,
                max: _totalDuration.inSeconds.toDouble(),
                onChanged: (value) {
                  _seekToPosition(value); // Change la position de la musique
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_currentPosition),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    _formatDuration(_totalDuration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.backward,
                        color: Colors.white),
                    onPressed: _previousTrack, // Passe à la piste précédente
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
                    onPressed: _nextTrack, // Passe à la piste suivante
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Formate la durée en minutes:secondes
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
