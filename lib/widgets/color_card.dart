import 'package:flutter/material.dart';

import '../models/color_info.dart';
import 'color_swatch.dart';

class ColorCard extends StatelessWidget {
  final ColorInfo colorInfo;
  final VoidCallback? onTap;

  const ColorCard({super.key, required this.colorInfo, this.onTap});

  Color get displayColor {
    final hex = colorInfo.hex.replaceAll('#', '');

    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppColorSwatch(color: displayColor, height: 100),
              const SizedBox(height: 12),
              Text(
                colorInfo.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                colorInfo.hex,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
