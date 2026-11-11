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
          scaffoldBackgroundColor: const Color(0xFFF9F7FF),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF9F7FF),
            elevation: 0,
            centerTitle: false,
          ),
        ),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    ExplorePage(),
    CollectionPage(),
    ContrastCheckerPage(),
  ];

  final List<String> pageTitles = [
    'Home',
    'Explore Colors',
    'My Collection',
    'Contrast Checker',
  ];

  void selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop)
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: selectPage,
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.white,
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
                      icon: Icon(Icons.color_lens_outlined),
                      selectedIcon: Icon(Icons.color_lens),
                      label: Text('Explore'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bookmark_border),
                      selectedIcon: Icon(Icons.bookmark),
                      label: Text('Collection'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.contrast_outlined),
                      selectedIcon: Icon(Icons.contrast),
                      label: Text('Contrast'),
                    ),
                  ],
                ),
              if (isDesktop)
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFECE8F5),
                ),
              Expanded(
                child: Column(
                  children: [
                    if (isDesktop)
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          pageTitles[selectedIndex],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex,
                        children: pages,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isDesktop
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: selectPage,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.color_lens_outlined),
                      selectedIcon: Icon(Icons.color_lens),
                      label: 'Explore',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bookmark_border),
                      selectedIcon: Icon(Icons.bookmark),
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
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8065F6), Color(0xFFE58ACD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to ColorMate!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Explore colors, create beautiful palettes, '
                  'and discover the meaning behind every color.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () {
                    openPage(context, const ColorPickerPage());
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8065F6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.colorize),
                  label: const Text('Start Picking Colors'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Explore Features',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover tools to help you work with colors.',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1000 ? 3 : 2;

              final features = [
                FeatureItem(
                  title: 'Explore Colors',
                  description: 'Discover different colors and their details.',
                  icon: Icons.color_lens_rounded,
                  color: const Color(0xFF8065F6),
                  page: const ExplorePage(),
                ),
                FeatureItem(
                  title: 'My Collection',
                  description: 'View your saved color palettes.',
                  icon: Icons.bookmark_rounded,
                  color: const Color(0xFFEC8DBD),
                  page: const CollectionPage(),
                ),
                FeatureItem(
                  title: 'Color Picker',
                  description: 'Choose and save your favorite colors.',
                  icon: Icons.colorize_rounded,
                  color: const Color(0xFF36B9A5),
                  page: const ColorPickerPage(),
                ),
                FeatureItem(
                  title: 'Palette Generator',
                  description: 'Generate harmonious color combinations.',
                  icon: Icons.palette_rounded,
                  color: const Color(0xFFFFA45B),
                  page: const PaletteGeneratorPage(),
                ),
                FeatureItem(
                  title: 'Color Mixing',
                  description: 'Mix two colors to create a new color.',
                  icon: Icons.science_rounded,
                  color: const Color(0xFF5798E8),
                  page: const ColorMixingPage(),
                ),
                FeatureItem(
                  title: 'Contrast Checker',
                  description: 'Check color contrast for readability.',
                  icon: Icons.contrast_rounded,
                  color: const Color(0xFF9B82D9),
                  page: const ContrastCheckerPage(),
                ),
              ];

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth < 400 ? 1.05 : 1.35,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];

                  return _FeatureCard(
                    feature: feature,
                    onTap: () {
                      openPage(context, feature.page);
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 28),
          const Center(
            child: Text(
              'ColorMate • Make Every Color Meaningful',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget page;

  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.page,
  });
}

class _FeatureCard extends StatelessWidget {
  final FeatureItem feature;
  final VoidCallback onTap;

  const _FeatureCard({required this.feature, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: feature.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(feature.icon, color: feature.color, size: 26),
              ),
              const SizedBox(height: 14),
              Text(
                feature.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                feature.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
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

class ContrastCheckerPage extends StatefulWidget {
  const ContrastCheckerPage({super.key});

  @override
  State<ContrastCheckerPage> createState() => _ContrastCheckerPageState();
}

class _ContrastCheckerPageState extends State<ContrastCheckerPage> {
  Color foregroundColor = Colors.black;
  Color backgroundColor = Colors.white;

  double get contrastRatio {
    final first = foregroundColor.computeLuminance();
    final second = backgroundColor.computeLuminance();

    final lighter = first > second ? first : second;
    final darker = first > second ? second : first;

    return (lighter + 0.05) / (darker + 0.05);
  }

  String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  Color get oppositeColor {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  Future<void> chooseColor({required bool isForeground}) async {
    final controller = TextEditingController(
      text: colorToHex(isForeground ? foregroundColor : backgroundColor),
    );

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isForeground ? 'Choose Text Color' : 'Choose Background Color',
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'HEX Color',
              hintText: '#8065F6',
              prefixIcon: Icon(Icons.palette_outlined),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!mounted || result == null) return;

    try {
      final hex = result.replaceAll('#', '');

      if (hex.length != 6) {
        throw const FormatException();
      }

      final color = Color(int.parse('FF$hex', radix: 16));

      setState(() {
        if (isForeground) {
          foregroundColor = color;
        } else {
          backgroundColor = color;
        }
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Format warna tidak valid. Gunakan HEX seperti #8065F6.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPass = contrastRatio >= 4.5;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contrast Checker',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Check whether your text and background colors '
                'have enough contrast for readability.',
                style: TextStyle(color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Text(
                      'ColorMate',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The quick brown fox jumps over the lazy dog.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foregroundColor, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preview of your selected color combination.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foregroundColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _ColorSelectionCard(
                title: 'Text Color',
                color: foregroundColor,
                hex: colorToHex(foregroundColor),
                onTap: () => chooseColor(isForeground: true),
              ),
              const SizedBox(height: 12),
              _ColorSelectionCard(
                title: 'Background Color',
                color: backgroundColor,
                hex: colorToHex(backgroundColor),
                onTap: () => chooseColor(isForeground: false),
              ),
              const SizedBox(height: 24),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${contrastRatio.toStringAsFixed(2)} : 1',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8065F6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isPass
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isPass ? 'WCAG AA Passed' : 'WCAG AA Not Passed',
                        style: TextStyle(
                          color: isPass ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Minimum contrast ratio for normal text: 4.5 : 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    foregroundColor = Colors.black;
                    backgroundColor = Colors.white;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Colors'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorSelectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final String hex;
  final VoidCallback onTap;

  const _ColorSelectionCard({
    required this.title,
    required this.color,
    required this.hex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(hex, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined),
          ],
        ),
      ),
    );
  }
}
