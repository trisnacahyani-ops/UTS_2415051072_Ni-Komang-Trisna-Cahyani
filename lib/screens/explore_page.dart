import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../widgets/color_card.dart';
import '../widgets/loading_widget.dart';
import 'color_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
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

          // Empty State
          if (provider.colors.isEmpty) {
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
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
