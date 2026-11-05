import 'package:flutter/material.dart';

import '../models/palette.dart';
import '../repositories/palette_repository.dart';

class PaletteProvider extends ChangeNotifier {
  final PaletteRepository repository;

  PaletteProvider({required this.repository});

  List<Palette> _palettes = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Palette> get palettes => _palettes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPalettes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _palettes = await repository.getPalettes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPalette(Palette palette) async {
    try {
      final saved = await repository.createPalette(palette);
      _palettes.insert(0, saved);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> editPalette(Palette palette) async {
    try {
      final updated = await repository.updatePalette(palette);

      final index = _palettes.indexWhere((item) => item.id == updated.id);

      if (index != -1) {
        _palettes[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removePalette(int id) async {
    try {
      await repository.deletePalette(id);

      _palettes.removeWhere((item) => item.id == id);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
