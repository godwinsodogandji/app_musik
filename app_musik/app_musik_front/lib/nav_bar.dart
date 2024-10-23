import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView( 
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Text(
              'Music Player',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Main menu',
              style: TextStyle(
              ),
            ),
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
