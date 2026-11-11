import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorWheel extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorWheel({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<ColorWheel> createState() => _ColorWheelState();
}

class _ColorWheelState extends State<ColorWheel> {
  late double selectedHue;
  double rotation = 0;
  double? lastAngle;

  @override
  void initState() {
    super.initState();
    selectedHue = HSVColor.fromColor(widget.initialColor).hue;
  }

  double _getAngle(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    return math.atan2(position.dy - center.dy, position.dx - center.dx);
  }

  void _selectColor(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    final distance = math.sqrt(dx * dx + dy * dy);
    final radius = size.width / 2;

    if (distance < radius * 0.43 || distance > radius * 1.02) {
      return;
    }

    final angle = _getAngle(position, size);

    final hue =
        ((angle * 180 / math.pi - rotation * 180 / math.pi) % 360 + 360) % 360;

    setState(() {
      selectedHue = hue;
    });

    widget.onColorChanged(HSVColor.fromAHSV(1, hue, 0.85, 0.95).toColor());
  }

  void _handlePanStart(DragStartDetails details, Size size) {
    lastAngle = _getAngle(details.localPosition, size);
    _selectColor(details.localPosition, size);
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    final currentAngle = _getAngle(details.localPosition, size);

    if (lastAngle != null) {
      var delta = currentAngle - lastAngle!;

      if (delta > math.pi) delta -= 2 * math.pi;
      if (delta < -math.pi) delta += 2 * math.pi;

      setState(() {
        rotation += delta;
      });
    }

    lastAngle = currentAngle;
    _selectColor(details.localPosition, size);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 300.0;

        final diameter = math.min(availableWidth, 300.0);
        final size = Size(diameter, diameter);

        return Center(
          child: SizedBox(
            width: diameter,
            height: diameter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) => _handlePanStart(details, size),
              onPanUpdate: (details) => _handlePanUpdate(details, size),
              onPanEnd: (_) => lastAngle = null,
              child: CustomPaint(
                painter: _ColorWheelPainter(
                  selectedHue: selectedHue,
                  rotation: rotation,
                ),
                child: Center(
                  child: Container(
                    width: diameter * 0.68,
                    height: diameter * 0.68,
                    decoration: BoxDecoration(
                      color: HSVColor.fromAHSV(
                        1,
                        selectedHue,
                        0.85,
                        0.95,
                      ).toColor(),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.colorize_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ColorWheelPainter extends CustomPainter {
  final double selectedHue;
  final double rotation;

  _ColorWheelPainter({required this.selectedHue, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const segments = 360;

    for (int i = 0; i < segments; i++) {
      final hue = i.toDouble();
      final startAngle = (hue * math.pi / 180) + rotation;

      final paint = Paint()
        ..color = HSVColor.fromAHSV(1, hue, 0.85, 0.95).toColor()
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        (2 * math.pi / segments) + 0.003,
        true,
        paint,
      );
    }

    final markerAngle = (selectedHue * math.pi / 180) + rotation;
    final markerRadius = radius * 0.85;

    final marker = Offset(
      center.dx + math.cos(markerAngle) * markerRadius,
      center.dy + math.sin(markerAngle) * markerRadius,
    );

    canvas.drawCircle(marker, radius * 0.065, Paint()..color = Colors.white);

    canvas.drawCircle(
      marker,
      radius * 0.043,
      Paint()..color = HSVColor.fromAHSV(1, selectedHue, 0.85, 0.95).toColor(),
    );

    canvas.drawCircle(
      center,
      radius * 0.34,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _ColorWheelPainter oldDelegate) {
    return oldDelegate.selectedHue != selectedHue ||
        oldDelegate.rotation != rotation;
  }
}
