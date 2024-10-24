import 'package:app_musik_front/videos/screens/player_video.dart';
import 'package:app_musik_front/videos/video_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_musik_front/videos/models/video.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        backgroundColor: const Color.fromARGB(255, 236, 236, 242),
      ),
      body: const VideoScreen(
          apiUrl: 'http://localhost:8081/api/video'), // Remplacez par l'URL correcte
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String apiUrl;

  const VideoScreen({super.key, required this.apiUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoService _videoService;
  List<Video> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _videoService = VideoService(widget.apiUrl);
    _fetchVideos();
  }

  void _fetchVideos() async {
    try {
      List<Video> videos = await _videoService.fetchVideos();
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching videos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoCover(),
            _buildStatsSection(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildPlayAllSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCover() {
    return Stack(
      children: [
        Image.network(
          '../assets/06ceb25fedf3bf7c8d81472293c9ea05.jpg',
          height: 200,
          fit: BoxFit.cover,
        ),
        const Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Videos',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              Text('12',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold)),
              Text('VIDEO SERIES',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              Text('Choose 12 videos for you',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
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
    );
  }

  Widget _buildPlayAllSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PLAY ALL',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 16),
          ..._videos.map((video) => VideoItem(
              title: video.title,
              artist: video.genre,
              duration: video.duration,
               // Assurez-vous de passer l'ID ici
          )).toList(),
        ],
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

class VideoItem extends StatelessWidget {
  final String title;
  final String artist;


  const VideoItem({
    super.key,
    required this.title,
    required int duration,
    required this.artist,
  
  });

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
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayVideoPage(
                  title: title,
                  artist: artist,
                ),
              ));
            },
            child: const Icon(FontAwesomeIcons.play, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

