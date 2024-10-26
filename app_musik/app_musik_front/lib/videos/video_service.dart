import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

  Future<void> createVideo(Video video) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['title'] = video.title
        ..fields['director'] = video.director
        ..fields['genre'] = video.genre
        ..fields['duration'] = video.duration.toString()
        ..fields['resolution'] = video.resolution;

      // Convertir le fichier en bytes si nécessaire
      Uint8List fileBytes;
      if (video.file.startsWith('http://') || video.file.startsWith('https://')) {
        final response = await http.get(Uri.parse(video.file));
        if (response.statusCode == 200) {
          fileBytes = response.bodyBytes;
        } else {
          throw Exception('Failed to download file');
        }
      } else {
        fileBytes = await File(video.file).readAsBytes();
      }

      // Ajouter le fichier à la requête
      // ignore: await_only_futures
      request.files.add(await http.MultipartFile.fromBytes('file', fileBytes, filename: 'video.mp4'));

      final response = await request.send();

      if (response.statusCode != 201) {
        throw Exception('Failed to create video: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      throw Exception('Error creating video: $e');
    }
  }
}
