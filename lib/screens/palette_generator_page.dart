import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/palette.dart';
import '../providers/palette_provider.dart';

class PaletteGeneratorPage extends StatefulWidget {
  const PaletteGeneratorPage({super.key});

  @override
  State<PaletteGeneratorPage> createState() => _PaletteGeneratorPageState();
}

class _PaletteGeneratorPageState extends State<PaletteGeneratorPage> {
  static const Color primary = Color(0xFF8065F6);

  Color baseColor = const Color(0xFF8065F6);

  String selectedType = 'Analogous';

  List<Color> generatedColors = [];

  final TextEditingController nameController = TextEditingController();

  bool isSaving = false;

  final List<String> types = [
    'Analogous',
    'Complementary',
    'Triadic',
    'Monochromatic',
  ];

  final List<Color> baseColors = [
    Color(0xFF8065F6),
    Color(0xFFFF80AB),
    Color(0xFF26A69A),
    Color(0xFFFFB74D),
    Color(0xFF42A5F5),
    Color(0xFFEF5350),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
    Color(0xFF40C4FF),
    Color(0xFFFF7043),
    Color(0xFFB2DFDB),
    Color(0xFFE1BEE7),
  ];

  @override
  void initState() {
    super.initState();
    generatePalette();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  String getHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void generatePalette() {
    final hsv = HSVColor.fromColor(baseColor);
    final hue = hsv.hue;

    List<Color> colors;

    switch (selectedType) {
      case 'Complementary':
        colors = [hue, hue + 180, hue + 30, hue + 210, hue + 150].map((value) {
          final normalized = (value % 360 + 360) % 360;
          return HSVColor.fromAHSV(1, normalized, 0.75, 0.95).toColor();
        }).toList();
        break;

      case 'Triadic':
        colors = [hue, hue + 120, hue + 240, hue + 60, hue + 180].map((value) {
          final normalized = (value % 360 + 360) % 360;
          return HSVColor.fromAHSV(1, normalized, 0.75, 0.95).toColor();
        }).toList();
        break;

      case 'Monochromatic':
        colors = [
          HSVColor.fromAHSV(1, hue, 0.25, 1),
          HSVColor.fromAHSV(1, hue, 0.45, 0.95),
          HSVColor.fromAHSV(1, hue, 0.65, 0.85),
          HSVColor.fromAHSV(1, hue, 0.85, 0.75),
          HSVColor.fromAHSV(1, hue, 1, 0.65),
        ].map((e) => e.toColor()).toList();
        break;

      default:
        colors = [hue - 40, hue - 20, hue, hue + 20, hue + 40].map((value) {
          final normalized = (value % 360 + 360) % 360;
          return HSVColor.fromAHSV(1, normalized, 0.75, 0.95).toColor();
        }).toList();
    }

    setState(() {
      generatedColors = colors;
    });
  }

  Future<void> savePalette() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama palette terlebih dahulu')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final palette = Palette(
        name: nameController.text.trim(),
        colors: generatedColors.map(getHex).toList(),
        colorType: selectedType,
      );

      await context.read<PaletteProvider>().addPalette(palette);

      if (!mounted) return;

      nameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Palette berhasil disimpan ke Collection!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan palette: $e')));
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> copyColor(Color color) async {
    final hex = getHex(color);

    await Clipboard.setData(ClipboardData(text: hex));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$hex berhasil disalin'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget buildColorCard(Color color, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => copyColor(color),
        child: Container(
          height: 125,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              child: Text(
                getHex(color),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTypeButton(String type) {
    final isSelected = selectedType == type;

    return ChoiceChip(
      label: Text(type),
      selected: isSelected,
      selectedColor: const Color(0xFFEAE5FF),
      labelStyle: TextStyle(
        color: isSelected ? primary : Colors.black54,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      onSelected: (_) {
        setState(() {
          selectedType = type;
        });

        generatePalette();
      },
    );
  }

  Widget buildBaseColorSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: baseColors.map((color) {
        final isSelected = baseColor == color;

        return GestureDetector(
          onTap: () {
            setState(() {
              baseColor = color;
            });

            generatePalette();
          },
          child: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 3,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Palette Generator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 950),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Your Palette ✨',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Generate beautiful color combinations '
                      'for your creative projects.',
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 25),

                    // BASE COLOR
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Base Color',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 15),

                          buildBaseColorSelector(),

                          const SizedBox(height: 25),

                          const Text(
                            'Palette Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            runSpacing: 5,
                            children: types.map(buildTypeButton).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // GENERATED PALETTE
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Generated Palette',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            '$selectedType Color Combination',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: List.generate(
                              generatedColors.length,
                              (index) =>
                                  buildColorCard(generatedColors[index], index),
                            ),
                          ),

                          const SizedBox(height: 22),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: generatePalette,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Generate Again'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // SAVE PALETTE
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Save Your Palette',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Palette Name',
                              hintText: 'Example: Sunset Dreams',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.palette_outlined),
                            ),
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: isSaving ? null : savePalette,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                              ),
                              icon: isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save_rounded),
                              label: Text(
                                isSaving
                                    ? 'Saving...'
                                    : 'Save to My Collection',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
