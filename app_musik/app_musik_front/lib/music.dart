import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music'),
      ),
      body: const AlbumScreen(), // Insert the AlbumScreen here
    );
  }
}

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover image
            Stack(
              children: [
                Image.network(
                  'https://storage.googleapis.com/a1aa/image/UdF59lqFgUYjNBhSbqvyMbur9q1nBwWocVhIevVl6caNJ00JA.jpg',
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
                      Text('Album', style: TextStyle(color: Colors.white, fontSize: 24)),
                      Text('17', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                      Text('LYRIC SERIES', style: TextStyle(color: Colors.white, fontSize: 14)),
                      Text('Choose 17 songs for you', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                children:  [
                  Text('PLAY ALL', style: TextStyle(color: Colors.white, fontSize: 18)),
                   SizedBox(height: 16),
                  PlaylistItem(title: 'Lucid Dreams', artist: 'Juice WRLD'),
                  PlaylistItem(title: 'No Tears Left To Cry', artist: 'Ariana Grande'),
                  PlaylistItem(title: 'Look Alive', artist: 'BlocBoy JB'),
                  PlaylistItem(title: 'Never Be The Same', artist: 'Camila Cabello'),
                  PlaylistItem(title: 'Everybody Dies In Their Nightmares', artist: 'XXXTENTACION'),
                  PlaylistItem(title: 'Simple', artist: 'Florida Georgia Line'),
                  PlaylistItem(title: 'Freaky Friday', artist: 'Lil Dicky & Chris Brown'),
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

class PlaylistItem extends StatelessWidget {
  final String title;
  final String artist;

  const PlaylistItem({required this.title, required this.artist});

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
