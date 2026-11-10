import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../widgets/color_card.dart';
import '../widgets/color_wheel.dart';
import '../widgets/loading_widget.dart';
import 'color_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Color selectedColor = const Color(0xFF8065F6);

  String get selectedHex {
    return '#${selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  String get selectedRgb {
    final value = selectedColor.toARGB32();

    final red = (value >> 16) & 0xFF;
    final green = (value >> 8) & 0xFF;
    final blue = value & 0xFF;

    return 'RGB($red, $green, $blue)';
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ColorProvider>().fetchColors();
    });
  }

  Future<void> _refreshColors() async {
    await context.read<ColorProvider>().fetchColors();
  }

  Future<void> _copySelectedColor() async {
    await Clipboard.setData(ClipboardData(text: selectedHex));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$selectedHex berhasil disalin!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF8065F6),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildColorWheelSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
          children: [
            const Row(
              children: [
                Icon(
                  Icons.color_lens_rounded,
                  color: Color(0xFF8065F6),
                  size: 25,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Interactive Color Wheel',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29243B),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            const Text(
              'Drag the color wheel to discover your favorite colors.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: ColorWheel(
                initialColor: selectedColor,
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7FC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Color',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          selectedHex,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF29243B),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          selectedRgb,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: _copySelectedColor,
                    tooltip: 'Copy HEX',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEAE5FF),
                    ),
                    icon: const Icon(
                      Icons.copy_rounded,
                      color: Color(0xFF8065F6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                'Move your finger or mouse around the wheel to select a color.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE3EC),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 45,
                color: Color(0xFFE85D8E),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _refreshColors,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8065F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.palette_outlined,
            size: 55,
            color: Color(0xFF8065F6),
          ),

          const SizedBox(height: 14),

          const Text(
            'No colors available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Please try loading the colors again.',
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: _refreshColors,
            child: const Text('Load Colors'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        elevation: 0,

        title: const Text(
          'Explore Colors',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Color(0xFF29243B),
          ),
        ),

        actions: [
          IconButton(
            onPressed: _refreshColors,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF8065F6)),
            tooltip: 'Refresh colors',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Consumer<ColorProvider>(
        builder: (context, provider, child) {
          // Loading State
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          // Error State
          if (provider.errorMessage != null) {
            return _buildErrorState(provider.errorMessage!);
          }

          // Empty State
          if (provider.colors.isEmpty) {
            return _buildEmptyState();
          }

          // Success State
          return RefreshIndicator(
            color: const Color(0xFF8065F6),
            onRefresh: _refreshColors,

            child: LayoutBuilder(
              builder: (context, constraints) {
                final int columns;

                if (constraints.maxWidth >= 1100) {
                  columns = 5;
                } else if (constraints.maxWidth >= 800) {
                  columns = 4;
                } else if (constraints.maxWidth >= 550) {
                  columns = 3;
                } else {
                  columns = 2;
                }

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  slivers: [
                    // Header and Color Wheel
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Banner
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(22),

                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8065F6),
                                    Color(0xFFFF8EAB),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),

                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.color_lens_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),

                                  SizedBox(height: 12),

                                  Text(
                                    'Discover Your Colors ✨',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 7),

                                  Text(
                                    'Explore beautiful colors and find '
                                    'inspiration for your next design.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Color Wheel
                            _buildColorWheelSection(),

                            // All Colors Heading
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'All Colors',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF29243B),
                                    ),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),

                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAE5FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    '${provider.colors.length} Colors',
                                    style: const TextStyle(
                                      color: Color(0xFF8065F6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              'Tap a color to see its details and palette.',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Color Grid
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),

                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final color = provider.colors[index];

                          return ColorCard(
                            colorInfo: color,

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ColorDetailPage(colorInfo: color);
                                  },
                                ),
                              );
                            },
                          );
                        }, childCount: provider.colors.length),

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
