import 'package:flutter/material.dart';

class Video {
  final String title;
  final String director;
  final String genre;
  final int duration;
  final String file;
  final String resolution;
  final String createdAt;
  final String updatedAt;

  Video({
    required this.title,
    required this.director,
    required this.genre,
    required this.duration,
    required this.file,
    required this.resolution,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
  return Video(
    title: json['title'] ?? '',
    director: json['director'] ?? '',
    genre: json['genre'] ?? '',
    duration: json['duration'] ?? 0,
    file: json['file'] ?? '',
    resolution: json['resolution'] ?? '',
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );
}

}
