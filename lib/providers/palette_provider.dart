import 'package:flutter/material.dart';

import '../models/palette.dart';

class PaletteProvider extends ChangeNotifier {
  List<Palette> _palettes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Palette> get palettes => List.unmodifiable(_palettes);

  List<Palette> get favoritePalettes =>
      _palettes.where((palette) => palette.isFavorite).toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setPalettes(List<Palette> palettes) {
    _palettes = List.from(palettes);
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
