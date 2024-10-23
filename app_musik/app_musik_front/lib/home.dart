import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'nav_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Music'),
        backgroundColor: Colors.transparent,
      
      ),
      drawer: const NavBar(),
      body: Container(
        color: const Color(0xFF1A1A2E),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MV Section
              SectionTitle(title: 'Albums'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MusicItem(
                    imageUrl: 'assets/i2.jpg',
                    title: 'Wait For A Minute',
                    artist: 'Gabrielle Aplin',
                  ),
                  MusicItem(
                    imageUrl: 'assets/i1.jpg',
                    title: 'One Man\'s Dream',
                    artist: 'Yanni',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recommend Section
              SectionTitle(title: 'Artist'),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MusicGridItem(
                    imageUrl: 'assets/i3.webp',
                    title: 'Gims',
                    subtitle: '23 songs',
                  ),
                  MusicGridItem(
                    imageUrl: 'assets/i4.webp',
                    title: 'Davido',
                    subtitle: '25 songs',
                  ),
                  MusicGridItem(
                    imageUrl: 'assets/i5.jpg',
                    title: 'Zaho',
                    subtitle: '12 songs',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Album Section
              SectionTitle(title: 'Genre'),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MusicGridItem(
                    imageUrl: 'assets/i6.webp',
                    title: 'Hip-hop',
                  ),
                  MusicGridItem(
                    imageUrl: 'assets/i7.webp',
                    title: 'Jazz',
                  ),
                  MusicGridItem(
                    imageUrl: 'assets/i8.webp',
                    title: 'Classical',
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

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class MusicItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const MusicItem({required this.imageUrl, required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image.network(imageUrl, width: 150, height: 100, fit: BoxFit.cover,),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14.0, color: Colors.white)),
          Text(artist, style: TextStyle(fontSize: 12.0, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

class MusicGridItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;

  const MusicGridItem({required this.imageUrl, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 14.0, color: Colors.white)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: TextStyle(fontSize: 12.0, color: Colors.grey[400])),
        ],
      ],
    );
  }
}
