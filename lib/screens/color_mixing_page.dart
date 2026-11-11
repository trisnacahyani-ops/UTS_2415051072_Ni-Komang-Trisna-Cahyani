import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/palette.dart';
import '../providers/palette_provider.dart';

class ColorMixingPage extends StatefulWidget {
  const ColorMixingPage({super.key});

  @override
  State<ColorMixingPage> createState() => _ColorMixingPageState();
}

class _ColorMixingPageState extends State<ColorMixingPage>
    with SingleTickerProviderStateMixin {
  Color firstColor = const Color(0xFF42A5F5);
  Color secondColor = const Color(0xFFFFD740);

  Color? mixedColor;
  bool isMixed = false;
  bool isSaving = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _leftChickAnimation;
  late final Animation<Offset> _rightChickAnimation;

  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'color': const Color(0xFFEF5350)},
    {'name': 'Orange', 'color': const Color(0xFFFF9800)},
    {'name': 'Yellow', 'color': const Color(0xFFFFD740)},
    {'name': 'Green', 'color': const Color(0xFF66BB6A)},
    {'name': 'Blue', 'color': const Color(0xFF42A5F5)},
    {'name': 'Purple', 'color': const Color(0xFFAB47BC)},
    {'name': 'Pink', 'color': const Color(0xFFFF80AB)},
    {'name': 'Turquoise', 'color': const Color(0xFF40C4C4)},
    {'name': 'Peach', 'color': const Color(0xFFFFAB91)},
    {'name': 'Mint', 'color': const Color(0xFF80CBC4)},
    {'name': 'Lavender', 'color': const Color(0xFFB39DDB)},
    {'name': 'Brown', 'color': const Color(0xFF8D6E63)},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _leftChickAnimation = Tween<Offset>(
      begin: const Offset(-0.8, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rightChickAnimation = Tween<Offset>(
      begin: const Offset(0.8, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  String getRgb(Color color) {
    return 'RGB(${(color.r * 255).round()}, '
        '${(color.g * 255).round()}, '
        '${(color.b * 255).round()})';
  }

  void mixColors() {
    setState(() {
      mixedColor = Color.lerp(firstColor, secondColor, 0.5);
      isMixed = true;
    });

    _controller.forward(from: 0);
  }

  void swapColors() {
    setState(() {
      final temp = firstColor;
      firstColor = secondColor;
      secondColor = temp;
      mixedColor = null;
      isMixed = false;
    });

    _controller.reset();
  }

  void resetColors() {
    setState(() {
      firstColor = const Color(0xFF42A5F5);
      secondColor = const Color(0xFFFFD740);
      mixedColor = null;
      isMixed = false;
    });

    _controller.reset();
  }

  void selectColor(int index, Color color) {
    setState(() {
      if (index == 0) {
        firstColor = color;
      } else {
        secondColor = color;
      }

      mixedColor = null;
      isMixed = false;
    });

    _controller.reset();
  }

  Future<void> saveMixedColor() async {
    if (mixedColor == null || isSaving) return;

    final nameController = TextEditingController(text: 'My Color Mixing');

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Save Mixed Color'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Collection Name',
              hintText: 'Enter palette name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, nameController.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();

    if (!mounted || name == null) return;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a collection name.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final palette = Palette(
        name: name,
        colors: [getHex(firstColor), getHex(secondColor), getHex(mixedColor!)],
        colorType: 'Color Mixing',
      );

      await context.read<PaletteProvider>().addPalette(palette);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mixed color saved to My Collection!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save color: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        title: const Text(
          'Color Mixing',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: resetColors,
            tooltip: 'Reset colors',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 25),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildColorSelector(0)),
                          const SizedBox(width: 18),
                          Expanded(child: _buildColorSelector(1)),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildColorSelector(0),
                          const SizedBox(height: 16),
                          _buildColorSelector(1),
                        ],
                      ),

                    const SizedBox(height: 18),

                    Center(
                      child: OutlinedButton.icon(
                        onPressed: swapColors,
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: const Text('Swap Colors'),
                      ),
                    ),

                    const SizedBox(height: 25),
                    _buildMixingArea(),
                    const SizedBox(height: 25),
                    _buildResult(),
                    const SizedBox(height: 25),
                    _buildInformation(),
                    const SizedBox(height: 25),

                    Center(
                      child: Text(
                        'ColorMate • Make Every Color Meaningful',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8065F6), Color(0xFFB18CFA), Color(0xFFFF91BB)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🐥 Let’s Mix Colors!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Choose two colors and discover a beautiful new shade.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector(int index) {
    final selected = index == 0 ? firstColor : secondColor;
    final title = index == 0 ? 'First Color' : 'Second Color';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: selected,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: selected.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getHex(selected),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      getRgb(selected),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'Choose a color',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 11,
            runSpacing: 11,
            children: colors.map((item) {
              final color = item['color'] as Color;
              final isSelected = selected == color;

              return Tooltip(
                message: item['name'] as String,
                child: GestureDetector(
                  onTap: () => selectColor(index, color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF8065F6)
                            : Colors.black12,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMixingArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Ready to Mix?',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Watch the little chicks bring your colors together!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 115,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _leftChickAnimation,
                  child: const Text('🐥', style: TextStyle(fontSize: 65)),
                ),
                const SizedBox(width: 20),
                const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                SlideTransition(
                  position: _rightChickAnimation,
                  child: const Text('🐣', style: TextStyle(fontSize: 65)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 105,
              height: 75,
              decoration: BoxDecoration(
                color: mixedColor ?? const Color(0xFFF3F0FA),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: Text(
                  isMixed ? '🐤' : '?',
                  style: const TextStyle(fontSize: 35),
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: mixColors,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Mix Colors'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8065F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final result = mixedColor;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: result == null
          ? Container(
              key: const ValueKey('empty'),
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE5FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.color_lens_outlined,
                    color: Color(0xFF8065F6),
                    size: 42,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your mixed color will appear here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5F4BA8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              key: ValueKey(getHex(result)),
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your New Color!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    height: 145,
                    decoration: BoxDecoration(
                      color: result,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        getHex(result),
                        style: TextStyle(
                          color: result.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    getRgb(result),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Color successfully mixed!',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : saveMixedColor,
                      icon: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.bookmark_add_rounded),
                      label: Text(
                        isSaving ? 'Saving...' : 'Save to My Collection',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8065F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡', style: TextStyle(fontSize: 25)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Color Mixing Tip',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Blue + Yellow can produce a green-like shade. '
                  'Try different combinations to discover new colors!',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.black54,
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
