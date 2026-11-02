import 'package:flutter/material.dart';

import '../models/color_info.dart';
import '../repositories/color_repository.dart';

class ColorProvider extends ChangeNotifier {
  final ColorRepository _repository;

  ColorProvider({required this._repository});

  bool _isLoading = false;
  String? _errorMessage;
  ColorInfo? _selectedColor;
  List<String> _generatedPalette = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ColorInfo? get selectedColor => _selectedColor;
  List<String> get generatedPalette => _generatedPalette;

  Future<void> fetchColorInfo(String hex) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedColor = await _repository.getColorInfo(hex);
    } catch (e) {
      _errorMessage = 'Gagal mengambil informasi warna.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generatePalette({
    required String hex,
    String mode = 'analogic',
    int count = 5,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _generatedPalette = await _repository.generatePalette(
        hex: hex,
        mode: mode,
        count: count,
      );
    } catch (e) {
      _errorMessage = 'Gagal membuat kombinasi warna.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
