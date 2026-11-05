class Palette {
  final int? id;
  final String name;
  final List<String> colors;
  final String colorType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Palette({
    this.id,
    required this.name,
    required this.colors,
    this.colorType = 'Custom',
    this.createdAt,
    this.updatedAt,
  });

  factory Palette.fromJson(Map<String, dynamic> json) {
    return Palette(
      id: json['id'] as int?,
      name: json['name'] as String,
      colors: List<String>.from(json['colors'] ?? []),
      colorType: json['color_type'] ?? 'Custom',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'colors': colors, 'color_type': colorType};
  }

  Palette copyWith({
    int? id,
    String? name,
    List<String>? colors,
    String? colorType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Palette(
      id: id ?? this.id,
      name: name ?? this.name,
      colors: colors ?? this.colors,
      colorType: colorType ?? this.colorType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
