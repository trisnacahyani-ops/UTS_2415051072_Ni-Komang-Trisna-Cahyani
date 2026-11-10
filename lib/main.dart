import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// CONFIG
import 'config/supabase_config.dart';

// PROVIDERS
import 'providers/color_provider.dart';
import 'providers/palette_provider.dart';

// REPOSITORIES
import 'repositories/color_repository.dart';
import 'repositories/palette_repository.dart';

// SERVICES
import 'services/color_api_service.dart';
import 'services/palette_supabase_service.dart';

// SCREENS
import 'screens/explore_page.dart';
import 'screens/collection_page.dart';
import 'screens/color_picker_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const ColorMateApp());
}

class ColorMateApp extends StatelessWidget {
  const ColorMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorProvider(
            repository: ColorRepository(apiService: ColorApiService()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PaletteProvider(
            repository: PaletteRepository(service: PaletteSupabaseService()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ColorMate',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8065F6),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F7FC),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF8F7FC),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const MainShell(),
      ),
    );
  }
}

// =====================================================
// MAIN NAVIGATION
// =====================================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onNavigateToCollection: () => _navigateToTab(2),
        onNavigateToExplore: () => _navigateToTab(1),
        onNavigateToColorPicker: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ColorPickerPage()),
          );
        },
        onNavigateToContrast: () => _navigateToTab(3),
      ),
      const ExplorePage(),
      const CollectionPage(),
      const FeatureScreen(
        title: 'Contrast Checker',
        subtitle: 'Check color contrast and accessibility.',
        icon: Icons.contrast_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _navigateToTab,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.white,
                  selectedIconTheme: const IconThemeData(
                    color: Color(0xFF8065F6),
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: Color(0xFF8065F6),
                    fontWeight: FontWeight.bold,
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Icon(
                      Icons.palette_rounded,
                      size: 34,
                      color: Color(0xFF8065F6),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
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
                child: IndexedStack(index: _selectedIndex, children: pages),
              ),
            ],
          ),
          bottomNavigationBar: isDesktop
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _navigateToTab,
                  backgroundColor: Colors.white,
                  indicatorColor: const Color(0xFFEAE5FF),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
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

// =====================================================
// HOME SCREEN
// =====================================================

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToCollection;
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToColorPicker;
  final VoidCallback onNavigateToContrast;

  const HomeScreen({
    super.key,
    required this.onNavigateToCollection,
    required this.onNavigateToExplore,
    required this.onNavigateToColorPicker,
    required this.onNavigateToContrast,
  });

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera hadir!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 20,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8065F6), Color(0xFFFF83B5)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.palette_rounded,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ColorMate',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF29243D),
                                ),
                              ),
                              Text(
                                'Your creative color companion',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // WELCOME BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF8065F6),
                              Color(0xFFB18CFA),
                              Color(0xFFFF91BB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome to ColorMate!',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Explore beautiful colors, create your own '
                              'palettes, and bring your creativity to life.',
                              style: TextStyle(
                                color: Colors.white,
                                height: 1.5,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: onNavigateToExplore,
                              icon: const Icon(Icons.explore_rounded),
                              label: const Text('Explore Colors'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF8065F6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SECTION TITLE
                      const Text(
                        'Explore Features',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF29243D),
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Everything you need to work with colors.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),

                      const SizedBox(height: 20),

                      // FEATURE GRID
                      GridView.count(
                        crossAxisCount: isWide ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: isWide ? 1.35 : 0.95,
                        children: [
                          _FeatureCard(
                            title: 'Explore Colors',
                            subtitle: 'Discover beautiful colors',
                            icon: Icons.explore_rounded,
                            color: const Color(0xFFEAE5FF),
                            iconColor: const Color(0xFF8065F6),
                            onTap: onNavigateToExplore,
                          ),
                          _FeatureCard(
                            title: 'My Collection',
                            subtitle: 'Manage saved palettes',
                            icon: Icons.collections_rounded,
                            color: const Color(0xFFFFE4EF),
                            iconColor: const Color(0xFFE66A9C),
                            onTap: onNavigateToCollection,
                          ),
                          _FeatureCard(
                            title: 'Color Picker',
                            subtitle: 'Choose your own colors',
                            icon: Icons.colorize_rounded,
                            color: const Color(0xFFFFE8CF),
                            iconColor: const Color(0xFFE99A43),
                            onTap: onNavigateToColorPicker,
                          ),
                          _FeatureCard(
                            title: 'Palette Generator',
                            subtitle: 'Create color combinations',
                            icon: Icons.auto_awesome_rounded,
                            color: const Color(0xFFDDF5EA),
                            iconColor: const Color(0xFF45A77A),
                            onTap: () {
                              _showComingSoon(context, 'Palette Generator');
                            },
                          ),
                          _FeatureCard(
                            title: 'Contrast Checker',
                            subtitle: 'Check color accessibility',
                            icon: Icons.contrast_rounded,
                            color: const Color(0xFFDDEEFF),
                            iconColor: const Color(0xFF4C91D8),
                            onTap: onNavigateToContrast,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // FOOTER
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
      ),
    );
  }
}

// =====================================================
// FEATURE CARD
// =====================================================

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _FeatureCard({
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
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// FEATURE SCREEN
// =====================================================

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
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE5FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, color: const Color(0xFF8065F6), size: 50),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Chip(
                label: Text('Coming Soon'),
                backgroundColor: Color(0xFFEAE5FF),
                side: BorderSide.none,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
