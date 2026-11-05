import 'dart:convert';

import 'package:http/http.dart' as http;

class ColorApiService {
  static const String baseUrl = 'https://www.thecolorapi.com';

  Future<List<dynamic>> getColorPalette({
    String hex = '8065F6',
    String mode = 'analogic',
    int count = 5,
  }) async {
    final cleanHex = hex.replaceAll('#', '');

    final uri = Uri.parse('$baseUrl/scheme').replace(
      queryParameters: {
        'hex': cleanHex,
        'mode': mode,
        'count': count.toString(),
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['colors'] as List<dynamic>;
    } else {
      throw Exception('Failed to load colors: ${response.statusCode}');
    }
  }
}
