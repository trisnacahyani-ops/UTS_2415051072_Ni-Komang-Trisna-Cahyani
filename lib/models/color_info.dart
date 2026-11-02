class ColorInfo {
  final String name;
  final String hex;
  final int red;
  final int green;
  final int blue;
  final String rgb;
  final String hsl;

  const ColorInfo({
    required this.name,
    required this.hex,
    required this.red,
    required this.green,
    required this.blue,
    required this.rgb,
    required this.hsl,
  });

  factory ColorInfo.fromJson(Map<String, dynamic> json) {
    final color = json['rgb'];

    return ColorInfo(
      name: json['name']['value'] ?? 'Unknown',
      hex: json['hex']['value'] ?? '#000000',
      red: color['r'] ?? 0,
      green: color['g'] ?? 0,
      blue: color['b'] ?? 0,
      rgb: color['value'] ?? 'rgb(0, 0, 0)',
      hsl: json['hsl']['value'] ?? 'hsl(0, 0%, 0%)',
    );
  }
}
