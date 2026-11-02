import '../models/color_info.dart';
import '../services/color_api_service.dart';

class ColorRepository {
  final ColorApiService _apiService;

  ColorRepository({required this._apiService});

  Future<ColorInfo> getColorInfo(String hex) {
    return _apiService.getColorInfo(hex);
  }

  Future<List<String>> generatePalette({
    required String hex,
    String mode = 'analogic',
    int count = 5,
  }) {
    return _apiService.generatePalette(hex: hex, mode: mode, count: count);
  }
}
