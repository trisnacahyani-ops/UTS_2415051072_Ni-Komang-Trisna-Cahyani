import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/color_info.dart';

class ColorDetailPage extends StatelessWidget {
  final ColorInfo colorInfo;

  const ColorDetailPage({super.key, required this.colorInfo});

  Color get baseColor {
    final hex = colorInfo.hex.replaceAll('#', '');

    return Color(int.parse('FF$hex', radix: 16));
  }

  List<Color> get palette {
    return [
      Color.lerp(baseColor, Colors.white, 0.75)!,
      Color.lerp(baseColor, Colors.white, 0.45)!,
      baseColor,
      Color.lerp(baseColor, Colors.black, 0.20)!,
      Color.lerp(baseColor, Colors.black, 0.45)!,
    ];
  }

  String hexCode(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> copyHex(BuildContext context, String hex) async {
    await Clipboard.setData(ClipboardData(text: hex));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$hex berhasil disalin!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF8065F6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Color Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: isWide ? 280 : 220,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: baseColor.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          colorInfo.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 8),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Color Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _infoRow('Color Name', colorInfo.name),
                          const Divider(height: 24),
                          _infoRow(
                            'HEX Code',
                            colorInfo.hex,
                            onCopy: () => copyHex(context, colorInfo.hex),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Generated Color Palette',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Explore lighter and darker variations '
                      'of your selected color.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),

                    const SizedBox(height: 18),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: palette.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 5 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isWide ? 0.9 : 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final color = palette[index];
                        final hex = hexCode(color);

                        return InkWell(
                          onTap: () => copyHex(context, hex),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hex,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Tap to copy',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value, {VoidCallback? onCopy}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded, color: Color(0xFF8065F6)),
            tooltip: 'Copy HEX',
          ),
      ],
    );
  }
}
