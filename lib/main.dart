import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';

import 'providers/color_provider.dart';
import 'providers/palette_provider.dart';

import 'repositories/color_repository.dart';
import 'repositories/palette_repository.dart';

import 'services/color_api_service.dart';
import 'services/palette_supabase_service.dart';

import 'screens/explore_page.dart';
import 'screens/collection_page.dart';
import 'screens/color_picker_page.dart';
import 'screens/palette_generator_page.dart';
import 'screens/color_mixing_page.dart';

// =====================================================
// MAIN
// =====================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const ColorMateApp());
}

// =====================================================
// APP
// =====================================================

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

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onNavigateToCollection: () => _navigateToTab(2),
        onNavigateToExplore: () => _navigateToTab(1),
        onNavigateToColorPicker: () {
          _openPage(const ColorPickerPage());
        },
        onNavigateToContrast: () => _navigateToTab(3),
        onNavigateToPaletteGenerator: () {
          _openPage(const PaletteGeneratorPage());
        },
        onNavigateToColorMixing: () {
          _openPage(const ColorMixingPage());
        },
      ),
      const ExplorePage(),
      const CollectionPage(),
      const ContrastCheckerPage(),
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
  final VoidCallback onNavigateToPaletteGenerator;
  final VoidCallback onNavigateToColorMixing;

  const HomeScreen({
    super.key,
    required this.onNavigateToCollection,
    required this.onNavigateToExplore,
    required this.onNavigateToColorPicker,
    required this.onNavigateToContrast,
    required this.onNavigateToPaletteGenerator,
    required this.onNavigateToColorMixing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            final columns = constraints.maxWidth >= 1000
                ? 3
                : constraints.maxWidth >= 550
                ? 2
                : 2;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 18,
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
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: isWide ? 1.20 : 0.85,
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
                            onTap: onNavigateToPaletteGenerator,
                          ),

                          // COLOR MIXING
                          _FeatureCard(
                            title: 'Color Mixing',
                            subtitle: 'Mix colors with cute animated chicks',
                            icon: Icons.science_rounded,
                            color: const Color(0xFFFFE4B5),
                            iconColor: const Color(0xFFE99A43),
                            onTap: onNavigateToColorMixing,
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

                      // COLOR MIXING QUICK ACCESS
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        child: InkWell(
                          onTap: onNavigateToColorMixing,
                          borderRadius: BorderRadius.circular(22),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              children: [
                                const Text(
                                  '🐥',
                                  style: TextStyle(fontSize: 42),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Let\'s Mix Colors!',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Combine colors and discover new shades.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFF8065F6),
                                  size: 19,
                                ),
                              ],
                            ),
                          ),
                        ),
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

                      const SizedBox(height: 20),
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
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  height: 1.2,
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CONTRAST CHECKER
// =====================================================

class ContrastCheckerPage extends StatefulWidget {
  const ContrastCheckerPage({super.key});

  @override
  State<ContrastCheckerPage> createState() => _ContrastCheckerPageState();
}

class _ContrastCheckerPageState extends State<ContrastCheckerPage> {
  Color foreground = Colors.black;
  Color background = Colors.white;

  double get contrastRatio {
    final lighter =
        foreground.computeLuminance() > background.computeLuminance()
        ? foreground.computeLuminance()
        : background.computeLuminance();

    final darker = foreground.computeLuminance() < background.computeLuminance()
        ? foreground.computeLuminance()
        : background.computeLuminance();

    return (lighter + 0.05) / (darker + 0.05);
  }

  @override
  Widget build(BuildContext context) {
    final readable = contrastRatio >= 4.5;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'Contrast Checker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check Color Accessibility',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Periksa apakah kombinasi warna teks dan latar belakang '
                  'mudah dibaca.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    'ColorMate Preview\nAa Bb Cc 123',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                _colorSelector(
                  title: 'Text Color',
                  selected: foreground,
                  onSelected: (color) {
                    setState(() => foreground = color);
                  },
                ),

                const SizedBox(height: 18),

                _colorSelector(
                  title: 'Background Color',
                  selected: background,
                  onSelected: (color) {
                    setState(() => background = color);
                  },
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Contrast Ratio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${contrastRatio.toStringAsFixed(2)} : 1',
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8065F6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        readable
                            ? 'PASS - Good readability'
                            : 'FAIL - Contrast needs improvement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: readable ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'WCAG AA untuk teks normal membutuhkan '
                        'rasio minimal 4.5 : 1.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      foreground = Colors.black;
                      background = Colors.white;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Colors'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorSelector({
    required String title,
    required Color selected,
    required ValueChanged<Color> onSelected,
  }) {
    const colors = [
      Colors.black,
      Colors.white,
      Color(0xFF8065F6),
      Color(0xFFFF80AB),
      Color(0xFF26A69A),
      Color(0xFFFFA45C),
      Color(0xFF42A5F5),
      Color(0xFFEF5350),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final isSelected = selected == color;

              return GestureDetector(
                onTap: () => onSelected(color),
                child: Container(
                  width: 39,
                  height: 39,
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
                          Icons.check,
                          size: 19,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
