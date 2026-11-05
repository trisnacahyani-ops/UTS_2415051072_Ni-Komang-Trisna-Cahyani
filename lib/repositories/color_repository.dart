import '../models/color_info.dart';
import '../services/color_api_service.dart';

class ColorRepository {
  final ColorApiService apiService;

  ColorRepository({required this.apiService});

  Future<List<ColorInfo>> getColorPalette({
    String hex = '8065F6',
    String mode = 'analogic',
    int count = 5,
  }) async {
    final result = await apiService.getColorPalette(
      hex: hex,
      mode: mode,
      count: count,
    );

    return result.map((json) => ColorInfo.fromJson(json)).toList();
  }
}
