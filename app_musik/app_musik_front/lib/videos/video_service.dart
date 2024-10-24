import 'dart:convert';
import 'package:app_musik_front/videos/models/video.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final String apiUrl;

  VideoService(this.apiUrl);

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((video) => Video.fromJson(video)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}