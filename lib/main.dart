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

// --------------------------------------------------
// MAIN
// --------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(
    MultiProvider(
      providers: [
        // COLOR PROVIDER - REST API
        ChangeNotifierProvider(
          create: (_) => ColorProvider(
            repository: ColorRepository(apiService: ColorApiService()),
          ),
        ),

        // PALETTE PROVIDER - SUPABASE
        ChangeNotifierProvider(
          create: (_) => PaletteProvider(
            repository: PaletteRepository(service: PaletteSupabaseService()),
          ),
        ),
      ],
      child: const ColorMateApp(),
    ),
  );
}

// --------------------------------------------------
// COLOR MATE APP
// --------------------------------------------------

class ColorMateApp extends StatelessWidget {
  const ColorMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorMate',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8065F6)),
        scaffoldBackgroundColor: const Color(0xFFF8F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F7FC),
          elevation: 0,
          centerTitle: false,
        ),
      ),

      home: const MainShell(),
    );
  }
}

// --------------------------------------------------
// MAIN NAVIGATION
// --------------------------------------------------

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
    CollectionPage(),
    FeatureScreen(
      title: 'Contrast Checker',
      subtitle: 'Check color contrast and accessibility.',
      icon: Icons.contrast_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEAE5FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette_rounded),
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
  }
}

// --------------------------------------------------
// HOME SCREEN
// --------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: const Text(
          'ColorMate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Color(0xFF29243B),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8065F6), Color(0xFFFF8EAB)],
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.color_lens_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Welcome to ColorMate!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Discover colors, create beautiful palettes, '
                            'and find inspiration for your designs.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Explore Features',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF29243B),
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.count(
                      crossAxisCount: isWide ? 3 : 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _FeatureCard(
                          title: 'Explore Colors',
                          subtitle: 'Discover color inspiration',
                          icon: Icons.palette_rounded,
                          color: const Color(0xFFEAE5FF),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ExplorePage(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'My Collection',
                          subtitle: 'Your saved palettes',
                          icon: Icons.collections_rounded,
                          color: const Color(0xFFFFE3EC),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CollectionPage(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Color Picker',
                          subtitle: 'Choose your own colors',
                          icon: Icons.colorize_rounded,
                          color: const Color(0xFFFFE8CF),
                          onTap: () {
                            _showComingSoon(context, 'Color Picker');
                          },
                        ),
                        _FeatureCard(
                          title: 'Palette Generator',
                          subtitle: 'Generate color combinations',
                          icon: Icons.auto_awesome_rounded,
                          color: const Color(0xFFDDF5E8),
                          onTap: () {
                            _showComingSoon(context, 'Palette Generator');
                          },
                        ),
                        _FeatureCard(
                          title: 'Contrast Checker',
                          subtitle: 'Check color accessibility',
                          icon: Icons.contrast_rounded,
                          color: const Color(0xFFFFF1B8),
                          onTap: () {
                            _showComingSoon(context, 'Contrast Checker');
                          },
                        ),
                      ],
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

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera tersedia.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// --------------------------------------------------
// FEATURE CARD
// --------------------------------------------------

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 27, color: const Color(0xFF8065F6)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// FEATURE SCREEN
// --------------------------------------------------

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 70, color: const Color(0xFF8065F6)),
              const SizedBox(height: 18),
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
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
