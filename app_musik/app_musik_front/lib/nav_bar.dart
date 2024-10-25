import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      50), 
                  child: Image.asset(
                    '../assets/1.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8), // Espace entre l'image et le texte
                const Text(
                  'God Music Player',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Main menu'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.video),
            title: const Text('Video'),
            onTap: () {
              Navigator.pushNamed(context, '/video');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Playlist'),
            onTap: () {
              Navigator.pushNamed(context, '/playlist');
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Music'),
            onTap: () {
              Navigator.pushNamed(context, '/music');
            },
          ),
        ],
      ),
    );
  }
}
