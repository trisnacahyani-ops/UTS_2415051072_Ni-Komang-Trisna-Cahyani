import 'package:flutter/material.dart';

class ChickAnimation extends StatefulWidget {
  final Color firstColor;
  final Color secondColor;
  final Color resultColor;
  final bool isMixing;

  const ChickAnimation({
    super.key,
    required this.firstColor,
    required this.secondColor,
    required this.resultColor,
    required this.isMixing,
  });

  @override
  State<ChickAnimation> createState() => _ChickAnimationState();
}

class _ChickAnimationState extends State<ChickAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _leftAnimation;
  late final Animation<double> _rightAnimation;
  late final Animation<double> _resultAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _leftAnimation = Tween<double>(begin: 0, end: 42).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.65, curve: Curves.easeInOut),
      ),
    );

    _rightAnimation = Tween<double>(begin: 0, end: -42).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.65, curve: Curves.easeInOut),
      ),
    );

    _resultAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(covariant ChickAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isMixing && !oldWidget.isMixing) {
      _controller.forward(from: 0);
    } else if (!widget.isMixing && oldWidget.isMixing) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _chick(Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '🐥',
              style: TextStyle(
                fontSize: 48,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.5), blurRadius: 12),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isCompleted = _controller.value >= 0.65;

        return SizedBox(
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.translate(
                    offset: Offset(_leftAnimation.value, 0),
                    child: _chick(widget.firstColor, 'Warna 1'),
                  ),
                  Transform.translate(
                    offset: Offset(_rightAnimation.value, 0),
                    child: _chick(widget.secondColor, 'Warna 2'),
                  ),
                ],
              ),
              if (isCompleted)
                Transform.scale(
                  scale: _resultAnimation.value,
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      color: widget.resultColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.resultColor, width: 3),
                    ),
                    child: const Center(
                      child: Text('🐣', style: TextStyle(fontSize: 62)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
