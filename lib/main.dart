import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/color_provider.dart';
import 'repositories/color_repository.dart';
import 'services/color_api_service.dart';
import 'screens/explore_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorProvider(
            repository: ColorRepository(apiService: ColorApiService()),
          ),
        ),
      ],
      child: const ColorMateApp(),
    ),
  );
}

class ColorMateApp extends StatelessWidget {
  const ColorMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorMate',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8065F6),
          brightness: Brightness.light,
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ExplorePage(),
    FeatureScreen(
      title: 'My Collection',
      subtitle: 'Your saved color palettes will appear here.',
      icon: Icons.collections_rounded,
    ),
    FeatureScreen(
      title: 'Contrast Checker',
      subtitle: 'Check color contrast and accessibility.',
      icon: Icons.contrast_rounded,
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        return Scaffold(
          body: Row(
            children: [
              if (isWide)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.white,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Icon(
                      Icons.palette_rounded,
                      color: Color(0xFF8065F6),
                      size: 32,
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.color_lens_outlined),
                      selectedIcon: Icon(Icons.color_lens_rounded),
                      label: Text('Explore'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.collections_outlined),
                      selectedIcon: Icon(Icons.collections_rounded),
                      label: Text('Collection'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.contrast_outlined),
                      selectedIcon: Icon(Icons.contrast_rounded),
                      label: Text('Contrast'),
                    ),
                  ],
                ),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  backgroundColor: Colors.white,
                  indicatorColor: const Color(0xFFEAE5FF),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.color_lens_outlined),
                      selectedIcon: Icon(Icons.color_lens_rounded),
                      label: 'Explore',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.collections_outlined),
                      selectedIcon: Icon(Icons.collections_rounded),
                      label: 'Collection',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.contrast_outlined),
                      selectedIcon: Icon(Icons.contrast_rounded),
                      label: 'Contrast',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAE5FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.palette_rounded,
                              color: Color(0xFF8065F6),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'ColorMate',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFFFE3EC),
                            child: Icon(
                              Icons.person_rounded,
                              color: Color(0xFFE85D8E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8065F6),
                              Color(0xFFB47CF5),
                              Color(0xFFFF8EAB),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello, Designer! 👋',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Find your perfect colors and create '
                              'beautiful palettes for your next design.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 22),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .findAncestorStateOfType<_MainShellState>()
                                    ?._onDestinationSelected(1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF8065F6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.color_lens_rounded),
                              label: const Text('Explore Colors'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Discover Features',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: isWide ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: isWide ? 1.35 : 1.05,
                        children: [
                          FeatureTile(
                            title: 'Explore Colors',
                            subtitle: 'Discover color combinations',
                            icon: Icons.color_lens_rounded,
                            color: const Color(0xFFEAE5FF),
                            iconColor: const Color(0xFF8065F6),
                            onTap: () {
                              context
                                  .findAncestorStateOfType<_MainShellState>()
                                  ?._onDestinationSelected(1);
                            },
                          ),
                          FeatureTile(
                            title: 'My Collection',
                            subtitle: 'Save your favorite palettes',
                            icon: Icons.collections_rounded,
                            color: const Color(0xFFFFE3EC),
                            iconColor: const Color(0xFFE85D8E),
                            onTap: () {
                              context
                                  .findAncestorStateOfType<_MainShellState>()
                                  ?._onDestinationSelected(2);
                            },
                          ),
                          FeatureTile(
                            title: 'Contrast Checker',
                            subtitle: 'Check color accessibility',
                            icon: Icons.contrast_rounded,
                            color: const Color(0xFFDDF5E8),
                            iconColor: const Color(0xFF36A879),
                            onTap: () {
                              context
                                  .findAncestorStateOfType<_MainShellState>()
                                  ?._onDestinationSelected(3);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'ColorMate helps you explore, create, '
                        'and manage beautiful color palettes.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
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
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const FeatureScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF8F7FC),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE5FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, size: 48, color: const Color(0xFF8065F6)),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
