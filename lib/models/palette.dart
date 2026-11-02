class Palette {
  final int? id;
  final String name;
  final String baseHex;
  final List<String> colors;
  final String schemeMode;
  final String description;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Palette({
    this.id,
    required this.name,
    required this.baseHex,
    required this.colors,
    required this.schemeMode,
    this.description = '',
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Palette.fromJson(Map<String, dynamic> json) {
    return Palette(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      baseHex: json['base_hex'] ?? '#000000',
      colors: List<String>.from(json['colors'] ?? []),
      schemeMode: json['scheme_mode'] ?? 'analogic',
      description: json['description'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'base_hex': baseHex,
      'colors': colors,
      'scheme_mode': schemeMode,
      'description': description,
      'is_favorite': isFavorite,
    };
  }
}
