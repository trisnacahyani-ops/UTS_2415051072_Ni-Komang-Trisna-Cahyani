import '../models/palette.dart';
import '../services/palette_supabase_service.dart';

class PaletteRepository {
  final PaletteSupabaseService service;

  PaletteRepository({required this.service});

  Future<List<Palette>> getPalettes() {
    return service.getPalettes();
  }

  Future<Palette> createPalette(Palette palette) {
    return service.createPalette(palette);
  }

  Future<Palette> updatePalette(Palette palette) {
    return service.updatePalette(palette);
  }

  Future<void> deletePalette(int id) {
    return service.deletePalette(id);
  }
}
