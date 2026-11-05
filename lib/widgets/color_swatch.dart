import 'package:flutter/material.dart';

class AppColorSwatch extends StatelessWidget {
  final Color color;
  final double height;
  final String? label;

  const AppColorSwatch({
    super.key,
    required this.color,
    this.height = 70,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(10),
      child: label == null
          ? null
          : Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
