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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'director': director,
      'genre': genre,
      'duration': duration,
      'file': file,
      'resolution': resolution,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      director: json['director'],
      genre: json['genre'],
      duration: json['duration'],
      file: json['file'],
      resolution: json['resolution'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
