import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
      ),
      body: const VideoScreen(), // Insert the VideoScreen here
    );
  }
}

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video cover image
            Stack(
              children: [
                Image.network(
                  'https://storage.googleapis.com/a1aa/image/sample-video-cover.jpg', // Replace with actual video cover image URL
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Videos', style: TextStyle(color: Colors.white, fontSize: 24)),
                      Text('12', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                      Text('VIDEO SERIES', style: TextStyle(color: Colors.white, fontSize: 14)),
                      Text('Choose 12 videos for you', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            // Stats section
            Container(
              color: const Color(0xFF2A2A3E),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatsItem(icon: FontAwesomeIcons.heart, count: '1,207'),
                  StatsItem(icon: FontAwesomeIcons.comment, count: '188'),
                  StatsItem(icon: FontAwesomeIcons.share, count: '1,339'),
                  StatsItem(icon: FontAwesomeIcons.star, count: '2,008'),
                ],
              ),
            ),

            // Play all section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PLAY ALL', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 16),
                  VideoItem(title: 'Music Video 1', artist: 'Artist 1'),
                  VideoItem(title: 'Music Video 2', artist: 'Artist 2'),
                  VideoItem(title: 'Music Video 3', artist: 'Artist 3'),
                  VideoItem(title: 'Music Video 4', artist: 'Artist 4'),
                  VideoItem(title: 'Music Video 5', artist: 'Artist 5'),
                  VideoItem(title: 'Music Video 6', artist: 'Artist 6'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsItem extends StatelessWidget {
  final IconData icon;
  final String count;

  const StatsItem({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(count, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class VideoItem extends StatelessWidget {
  final String title;
  final String artist;

  const VideoItem({required this.title, required this.artist});

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
              Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
              Text(artist, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          Icon(FontAwesomeIcons.play, color: Colors.white),
        ],
      ),
    );
  }
}
