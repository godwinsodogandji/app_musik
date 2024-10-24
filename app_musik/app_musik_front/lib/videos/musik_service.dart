// ignore_for_file: unused_import

import 'package:app_musik_front/videos/models/musik.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicService {
  final String apiUrl;

  MusicService(this.apiUrl);

  Future<List<Music>> fetchMusics() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((music) => Music.fromJson(music)).toList();
    } else {
      throw Exception('Failed to load music');
    }
  }
}
