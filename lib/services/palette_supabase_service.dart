import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/palette.dart';

class PaletteSupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  static const String _table = 'palettes';

  // READ
  Future<List<Palette>> getPalettes() async {
    final response = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((item) => Palette.fromJson(item)).toList();
  }

  // CREATE
  Future<Palette> createPalette(Palette palette) async {
    final response = await _client
        .from(_table)
        .insert(palette.toJson())
        .select()
        .single();

    return Palette.fromJson(response);
  }

  // UPDATE
  Future<Palette> updatePalette(Palette palette) async {
    if (palette.id == null) {
      throw Exception('ID palette tidak ditemukan');
    }

    final response = await _client
        .from(_table)
        .update({
          ...palette.toJson(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', palette.id!)
        .select()
        .single();

    return Palette.fromJson(response);
  }

  // DELETE
  Future<void> deletePalette(int id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
