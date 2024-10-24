import 'package:flutter/material.dart';

class Music {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int duration;
  final String file;
  final String createdAt;
  final String updatedAt;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.duration,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      album: json['album'] ?? '',
      genre: json['genre'] ?? '',
      duration: json['duration'] ?? 0,
      file: json['file'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
