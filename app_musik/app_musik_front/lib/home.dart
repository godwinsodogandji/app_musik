import 'package:app_musik_front/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importez le stockage partagé
import 'login_page.dart'; // Assurez-vous d'importer votre page de connexion

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _logout(BuildContext context) async {
    // Instance de stockage partagé
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Supprimer le token
    await prefs.remove('auth_token');

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully logged out')),
    );

    // Redirection vers la page de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Music'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                _logout(context), // Appel à la méthode de déconnexion
          ),
        ],
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
              const SectionTitle(title: 'Albums'),
              const Row(
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
              const SizedBox(height: 1),

              // Recommend Section
              const SectionTitle(title: 'Artist'),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/music');
                    },
                    child: const MusicGridItem(
                      imageUrl: 'assets/i3.webp',
                      title: 'Gims',
                      subtitle: '23 songs',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/music');
                    },
                    child: const MusicGridItem(
                      imageUrl: 'assets/i4.webp',
                      title: 'Davido',
                      subtitle: '25 songs',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/music');
                    },
                    child: const MusicGridItem(
                      imageUrl: 'assets/i5.jpg',
                      title: 'Zaho',
                      subtitle: '12 songs',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),

              // Album Section
              const SectionTitle(title: 'Genre'),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/music');
                    },
                    child: const MusicGridItem(
                      imageUrl: 'assets/i6.webp',
                      title: 'Hip-hop',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/music');
                    },
                    child: const MusicGridItem(
                      imageUrl: 'assets/i7.webp',
                      title: 'Jazz',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/music');
                    },
                    child: const MusicGridItem(
                      imageUrl: 'assets/i8.webp',
                      title: 'Classical',
                    ),
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

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class MusicItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const MusicItem(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.artist});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Image.network(
            imageUrl,
            width: 750,
            height: 500,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 1),
          Text(title,
              style: const TextStyle(fontSize: 14.0, color: Colors.white)),
          Text(artist,
              style: TextStyle(fontSize: 12.0, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

class MusicGridItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;

  const MusicGridItem(
      {super.key, required this.imageUrl, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(imageUrl, width: 500, height: 250, fit: BoxFit.cover),
        const SizedBox(height: 1),
        Text(title,
            style: const TextStyle(fontSize: 14.0, color: Colors.white)),
        if (subtitle != null) ...[
          const SizedBox(height: 1),
          Text(subtitle!,
              style: TextStyle(fontSize: 12.0, color: Colors.grey[400])),
        ],
      ],
    );
  }
}
