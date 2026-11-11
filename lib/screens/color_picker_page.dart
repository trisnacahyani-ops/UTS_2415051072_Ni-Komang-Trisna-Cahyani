import 'package:flutter/material.dart';

import '../widgets/color_wheel.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color selectedColor = const Color(0xFF8065F6);

  String get hexColor {
    final value = selectedColor.toARGB32();
    return '#${(value & 0xFFFFFF).toRadixString(16).toUpperCase().padLeft(6, '0')}';
  }

  int get red => (selectedColor.toARGB32() >> 16) & 0xFF;
  int get green => (selectedColor.toARGB32() >> 8) & 0xFF;
  int get blue => selectedColor.toARGB32() & 0xFF;

  void _updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void _resetColor() {
    setState(() {
      selectedColor = const Color(0xFF8065F6);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Color Picker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 750;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 24 : 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose Your Color',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF29243B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih warna dengan menggeser jari atau mouse '
                      'pada lingkaran warna.',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: _buildWheel()),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: _buildColorInformation()),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildWheel(),
                          const SizedBox(height: 20),
                          _buildColorInformation(),
                        ],
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

  Widget _buildWheel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Interactive Color Wheel',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ColorWheel(initialColor: selectedColor, onColorChanged: _updateColor),
          const SizedBox(height: 8),
          const Text(
            'Geser pada bagian lingkaran untuk memilih warna',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildColorInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Selected Color',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(height: 16),
          _buildValueRow('HEX', hexColor),
          const Divider(height: 22),
          _buildValueRow('RGB', '$red, $green, $blue'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetColor,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset Color'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
