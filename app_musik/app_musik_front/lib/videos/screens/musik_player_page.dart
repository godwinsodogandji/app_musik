import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_musik_front/videos/screens/music.dart';

class MusicPlayerPage extends StatefulWidget {
  final List<Music> musics;
  final int initialIndex;

  const MusicPlayerPage({
    super.key,
    required this.musics,
    this.initialIndex = 0,
    required String title,
    required String artist,
    required String audioFile,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;
  bool isPlaying = false;
  int currentIndex = 0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();

    currentIndex = widget.initialIndex;

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

    _loadMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadMusic() async {
    try {
      await _audioPlayer
          .setAsset('../../../assets/Sunny Fruit - Beat Blitz.mp3');
      _audioPlayer.play();
      setState(() {
        isPlaying = true;
        _animationController.repeat();
      });
    } catch (e) {
      print('Erreur de lecture: $e');
    }
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      _audioPlayer.pause();
      _animationController.stop();
    } else {
      _audioPlayer.play();
      _animationController.repeat();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _nextTrack() async {
    if (currentIndex < widget.musics.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _loadMusic();
    }
  }

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
    _audioPlayer.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    final currentMusic = widget.musics[currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Now Playing'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../../../assets/abstract-moon-start-lights.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController.value * 2.0 * 3.141592653589793,
                    child: child,
                  );
                },
                child: Container(
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
                  child: ClipOval(
                    child: Image.network(
                      'assets/vector-music-melody-note-dancing-flow/musbackround1_12.jpg',
                      height:
                          250, // largeur et hauteur égales pour un cercle parfait
                      width: 250,
                      fit: BoxFit.cover,
                    ),
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
              Slider(
                value: _currentPosition.inSeconds.toDouble(),
                min: 0.0,
                max: _totalDuration.inSeconds.toDouble(),
                onChanged: (value) {
                  _seekToPosition(value);
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
                    onPressed: _previousTrack,
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _togglePlayPause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isPlaying ? 'Pause' : 'Play',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.forward,
                        color: Colors.white),
                    onPressed: _nextTrack,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
