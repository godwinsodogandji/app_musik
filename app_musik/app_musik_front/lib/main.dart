

import 'package:app_musik_front/play_list.dart';
import 'package:app_musik_front/home.dart';
import 'package:app_musik_front/music.dart';
import 'package:app_musik_front/videos/screens/video.dart';


import 'package:flutter/material.dart';

import 'register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const Home(),
      routes: {
        '/home': (context) => const Home(),
        '/video': (context) => const VideoPage(),
        '/playlist': (context) => const PlayListPage(),
        '/music': (context) => const MusicPage(),
        
        
      },
    );
  }
}