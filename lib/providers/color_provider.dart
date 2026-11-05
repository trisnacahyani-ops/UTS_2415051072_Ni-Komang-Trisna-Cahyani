import 'package:flutter/material.dart';

import '../models/color_info.dart';
import '../repositories/color_repository.dart';

class ColorProvider extends ChangeNotifier {
  final ColorRepository repository;

  ColorProvider({required this.repository});

  List<ColorInfo> _colors = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ColorInfo> get colors => _colors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchColors({
    String hex = '8065F6',
    String mode = 'analogic',
    int count = 5,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _colors = await repository.getColorPalette(
        hex: hex,
        mode: mode,
        count: count,
      );
    } catch (error) {
      _errorMessage = 'Gagal mengambil data warna. Periksa koneksi internet.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
