import 'package:app_musik_front/videos/screens/player_video.dart';
import 'package:app_musik_front/videos/video_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_musik_front/videos/models/video.dart';
import 'package:app_musik_front/videos/screens/add_video_page.dart'; // Ajoutez l'importation pour AddVideoPage

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        backgroundColor: const Color.fromARGB(255, 236, 236, 242),
      ),
      body: const VideoScreen(apiUrl: 'http://localhost:8081/api/video'),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String apiUrl;

  const VideoScreen({super.key, required this.apiUrl});

  @override
  // ignore: library_private_types_in_public_api
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

  // Fonction pour afficher le modal d'ajout de vidéo
  void _showAddVideoModal() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: AddVideoPage(), // Utilisez votre widget de formulaire ici
        );
      },
    ).then((_) {
      _fetchVideos(); // Rechargez la liste des vidéos après l'ajout
    });
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: _showAddVideoModal, // Affichez le modal d'ajout
            child: const StatsItem(
              style: TextStyle(color: Colors.white),
              icon: FontAwesomeIcons.plus,
               tooltip: 'Ajouter',
              count: '', // Icône d'ajout
            ),
          ),
          const StatsItem(
            style: TextStyle(color: Colors.white),
            // ignore: deprecated_member_use
            icon: FontAwesomeIcons.edit,
             tooltip: 'Modifier',
            count: '', // Icône de modification
          ),
          const StatsItem(
            style: TextStyle(color: Colors.white),
            icon: FontAwesomeIcons.trash, count: '',
             tooltip: 'Supprimer'
           // Icône de suppression
          ),
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
          ..._videos
              .map((video) => VideoItem(
                    title: video.title,
                    artist: video.genre,
                    duration: video.duration,
                    // Assurez-vous de passer l'ID ici
                  ))
              .toList(),
        ],
      ),
    );
  }
}

class StatsItem extends StatelessWidget {
  final IconData icon;
  final String count;

  const StatsItem({
    Key? key,
    required this.icon,
    required this.count,
    required TextStyle style, required String tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
          color: const Color.fromARGB(255, 190, 192, 194),
        ),
        const SizedBox(height: 4),
        
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
                  style: const TextStyle(
                      color: Color.fromARGB(255, 6, 5, 5), fontSize: 14)),
              Text(artist,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 213, 211, 211), fontSize: 12)),
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
