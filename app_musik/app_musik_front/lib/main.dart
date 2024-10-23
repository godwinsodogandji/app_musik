

import 'package:app_musik_front/play_list.dart';
import 'package:app_musik_front/home.dart';
import 'package:app_musik_front/music.dart';
import 'package:app_musik_front/video.dart';


import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Home(),
      routes: {
        '/home': (context) => Home(),
        '/video': (context) => VideoPage(),
        '/playlist': (context) => PlayListPage(),
        '/music': (context) => MusicPage(),
        
        
      },
    );
  }
}
