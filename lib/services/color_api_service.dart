import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/color_info.dart';

class ColorApiService {
  static const String baseUrl = 'https://www.thecolorapi.com';

  Future<ColorInfo> getColorInfo(String hex) async {
    final response = await http.get(
      Uri.parse('$baseUrl/id?hex=${hex.replaceAll('#', '')}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ColorInfo.fromJson(data);
    } else {
      throw Exception('Failed to load color information');
    }
  }

  Future<List<String>> generatePalette({
    required String hex,
    String mode = 'analogic',
    int count = 5,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/scheme?hex=${hex.replaceAll('#', '')}'
        '&mode=$mode&count=$count',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['colors'] as List)
          .map((color) => color['hex']['value'] as String)
          .toList();
    } else {
      throw Exception('Failed to generate color palette');
    }
  }
}
