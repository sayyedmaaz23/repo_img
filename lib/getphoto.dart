import 'dart:convert';
import 'package:http/http.dart' as http;

class Unsplash {
  final String apiKey = 'Access_key';

  Future<List<String>> fetchImages(String query) async {
    final url = Uri.parse(
      'https://api.unsplash.com/search/photos?query=$query&client_id=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List images = data['results'];
      return images.map((img) => img['urls']['small'] as String).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
