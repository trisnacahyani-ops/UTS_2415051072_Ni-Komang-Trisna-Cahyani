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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const ColorMateApp());
}

// ==========================================
// MAIN APP
// ==========================================

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
        ),
        home: const MainShell(),
      ),
    );
  }
}

// ==========================================
// MAIN NAVIGATION
// ==========================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onContrastTap: () => _changeTab(3)),
      const ExplorePage(),
      const CollectionPage(),
      const FeatureScreen(
        title: 'Contrast Checker',
        icon: Icons.contrast,
        description:
            'Periksa kontras warna untuk membantu menghasilkan '
            'kombinasi warna yang nyaman dibaca.',
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_outlined),
            selectedIcon: Icon(Icons.collections),
            label: 'Collection',
          ),
          NavigationDestination(
            icon: Icon(Icons.contrast_outlined),
            selectedIcon: Icon(Icons.contrast),
            label: 'Contrast',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HOME SCREEN
// ==========================================

class HomeScreen extends StatelessWidget {
  final VoidCallback onContrastTap;

  const HomeScreen({super.key, required this.onContrastTap});

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 800;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 20,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xFFEAE3FF),
                            child: Icon(
                              Icons.palette,
                              color: Color(0xFF8065F6),
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ColorMate',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Explore your world of colors',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // HEADER BANNER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF8065F6),
                              Color(0xFFB77BEB),
                              Color(0xFFF29BCB),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover Your Colors',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Create beautiful color combinations, '
                              'explore palettes, and save your favorite colors.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Explore Features',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // FEATURE GRID
                      GridView.count(
                        crossAxisCount: isDesktop ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: isDesktop ? 1.5 : 1.15,
                        children: [
                          _FeatureCard(
                            title: 'Explore Colors',
                            description:
                                'Discover different color combinations',
                            icon: Icons.color_lens_outlined,
                            color: const Color(0xFF8065F6),
                            onTap: () {
                              _openPage(context, const ExplorePage());
                            },
                          ),

                          _FeatureCard(
                            title: 'My Collection',
                            description: 'View your saved color palettes',
                            icon: Icons.collections_bookmark_outlined,
                            color: const Color(0xFFEC82B5),
                            onTap: () {
                              _openPage(context, const CollectionPage());
                            },
                          ),

                          _FeatureCard(
                            title: 'Color Picker',
                            description: 'Choose colors using color wheel',
                            icon: Icons.colorize,
                            color: const Color(0xFF43B9B0),
                            onTap: () {
                              _openPage(context, const ColorPickerPage());
                            },
                          ),

                          _FeatureCard(
                            title: 'Palette Generator',
                            description: 'Generate beautiful color palettes',
                            icon: Icons.auto_awesome,
                            color: const Color(0xFFFFA45C),
                            onTap: () {
                              _openPage(context, const PaletteGeneratorPage());
                            },
                          ),

                          _FeatureCard(
                            title: 'Contrast Checker',
                            description: 'Check color contrast and readability',
                            icon: Icons.contrast,
                            color: const Color(0xFF6495ED),
                            onTap: onContrastTap,
                          ),

                          _FeatureCard(
                            title: 'Color Inspiration',
                            description: 'Find inspiration for your designs',
                            icon: Icons.lightbulb_outline,
                            color: const Color(0xFFB18AE8),
                            onTap: () {
                              _openPage(context, const ExplorePage());
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // COLOR TIP
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              color: Color(0xFF8065F6),
                              size: 30,
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Color Tip',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Try combining complementary colors '
                                    'to create a balanced and attractive design.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

// ==========================================
// FEATURE CARD
// ==========================================

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
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
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// FEATURE SCREEN
// ==========================================

class FeatureScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const FeatureScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 75, color: const Color(0xFF8065F6)),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
