import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorMixingPage extends StatefulWidget {
  const ColorMixingPage({super.key});

  @override
  State<ColorMixingPage> createState() => _ColorMixingPageState();
}

class _ColorMixingPageState extends State<ColorMixingPage>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = const [
    Color(0xFF2196F3),
    Color(0xFFFFD740),
    Color(0xFFFF80AB),
    Color(0xFF9C27B0),
    Color(0xFF26A69A),
    Color(0xFFFF8A65),
    Color(0xFF8065F6),
    Color(0xFF8BC34A),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  final List<String> colorNames = const [
    'Biru',
    'Kuning',
    'Pink',
    'Ungu',
    'Turquoise',
    'Peach',
    'Lavender',
    'Hijau',
    'Cokelat',
    'Abu-abu',
  ];

  int firstIndex = 0;
  int secondIndex = 1;

  Color? resultColor;
  bool hasMixed = false;

  late final AnimationController animationController;
  late final Animation<double> bounceAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Color mixColors(Color first, Color second) {
    final hsv1 = HSVColor.fromColor(first);
    final hsv2 = HSVColor.fromColor(second);

    double difference = hsv2.hue - hsv1.hue;

    if (difference > 180) {
      difference -= 360;
    } else if (difference < -180) {
      difference += 360;
    }

    final hue = (hsv1.hue + difference / 2 + 360) % 360;
    final saturation = (hsv1.saturation + hsv2.saturation) / 2;
    final value = (hsv1.value + hsv2.value) / 2;

    return HSVColor.fromAHSV(1, hue, saturation, value).toColor();
  }

  String getHex(Color color) {
    return '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).toUpperCase().padLeft(6, '0')}';
  }

  void mix() {
    setState(() {
      resultColor = mixColors(colors[firstIndex], colors[secondIndex]);
      hasMixed = true;
    });

    animationController.forward(from: 0);
  }

  Future<void> copyHex() async {
    if (resultColor == null) return;

    await Clipboard.setData(ClipboardData(text: getHex(resultColor!)));

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kode HEX berhasil disalin!')));
  }

  Widget colorOption(int index) {
    final selected = firstIndex == index || secondIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (firstIndex == index) {
            firstIndex = (index + 1) % colors.length;
          } else if (secondIndex == index) {
            secondIndex = (index + 1) % colors.length;
          }
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colors[index],
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? const Color(0xFF8065F6) : Colors.white,
            width: selected ? 4 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors[index].withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: selected
            ? Icon(
                Icons.check,
                color: colors[index].computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
              )
            : null,
      ),
    );
  }

  Widget chick(Color color, String label, {bool animated = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: animated
              ? Tween<double>(begin: 0.7, end: 1).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Curves.elasticOut,
                  ),
                )
              : const AlwaysStoppedAnimation(1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
              ),
              const Text('🐥', style: TextStyle(fontSize: 68)),
              Positioned(
                bottom: 5,
                right: 3,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          getHex(color),
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstColor = colors[firstIndex];
    final secondColor = colors[secondIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Color Mixing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8065F6), Color(0xFFFF8EAB)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🐥🎨', style: TextStyle(fontSize: 38)),
                          SizedBox(height: 12),
                          Text(
                            'Let’s Mix Colors!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pilih dua warna dan lihat warna baru '
                            'yang terbentuk dari kombinasi keduanya.',
                            style: TextStyle(color: Colors.white, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Choose Your Colors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pilih warna pertama dan kedua:',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(colors.length, colorOption),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: _selectedColor(
                                  'Warna 1',
                                  firstColor,
                                  colorNames[firstIndex],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _selectedColor(
                                  'Warna 2',
                                  secondColor,
                                  colorNames[secondIndex],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Color Mixing Station',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Flex(
                            direction: wide ? Axis.horizontal : Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              chick(firstColor, colorNames[firstIndex]),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 12,
                                ),
                                child: Icon(
                                  Icons.add_circle_rounded,
                                  color: const Color(0xFF8065F6),
                                  size: 35,
                                ),
                              ),
                              chick(secondColor, colorNames[secondIndex]),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Icon(
                            Icons.arrow_downward_rounded,
                            color: Color(0xFF8065F6),
                            size: 32,
                          ),

                          const SizedBox(height: 15),

                          if (hasMixed && resultColor != null)
                            ScaleTransition(
                              scale: bounceAnimation,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: resultColor,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '🐥',
                                      style: TextStyle(fontSize: 65),
                                    ),
                                    const Text(
                                      'New Color!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      getHex(resultColor!),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: copyHex,
                                      icon: const Icon(Icons.copy),
                                      label: const Text('Copy HEX'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F1FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Column(
                                children: [
                                  Text('🐣', style: TextStyle(fontSize: 65)),
                                  Text(
                                    'Warna hasil campuran akan muncul di sini!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF665A85),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: mix,
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text(
                                'Campurkan Warna!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8065F6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Catatan: hasil pencampuran ini merupakan simulasi '
                      'warna digital menggunakan pendekatan HSV, bukan '
                      'simulasi pigmen cat secara fisik.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selectedColor(String title, Color color, String name) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
