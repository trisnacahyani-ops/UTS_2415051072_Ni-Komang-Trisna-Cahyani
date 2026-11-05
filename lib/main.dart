import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/color_provider.dart';
import 'repositories/color_repository.dart';
import 'services/color_api_service.dart';

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
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF9F8FF),
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
  int selectedIndex = 0;

  final List<String> titles = ['Home', 'Explore', 'Collection', 'Contrast'];

  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.palette_rounded,
    Icons.bookmark_rounded,
    Icons.contrast_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        final pages = [
          HomeScreen(
            onNavigate: (index) {
              setState(() => selectedIndex = index);
            },
          ),
          const FeatureScreen(
            title: 'Explore Colors',
            subtitle: 'Find your next favorite color.',
            icon: Icons.palette_rounded,
            color: Color(0xFFFF8A9B),
          ),
          const FeatureScreen(
            title: 'My Collection',
            subtitle: 'Your saved color palettes.',
            icon: Icons.bookmark_rounded,
            color: Color(0xFF70C9B0),
          ),
          const FeatureScreen(
            title: 'Contrast Checker',
            subtitle: 'Make your designs easier to read.',
            icon: Icons.contrast_rounded,
            color: Color(0xFF8B78F6),
          ),
        ];

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (isWide)
                  NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() => selectedIndex = index);
                    },
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.white,
                    leading: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Icon(
                        Icons.color_lens_rounded,
                        size: 34,
                        color: Color(0xFF8065F6),
                      ),
                    ),
                    destinations: List.generate(
                      titles.length,
                      (index) => NavigationRailDestination(
                        icon: Icon(icons[index]),
                        label: Text(titles[index]),
                      ),
                    ),
                  ),
                Expanded(
                  child: IndexedStack(index: selectedIndex, children: pages),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                  backgroundColor: Colors.white,
                  indicatorColor: const Color(0xFFECE7FF),
                  destinations: List.generate(
                    titles.length,
                    (index) => NavigationDestination(
                      icon: Icon(icons[index]),
                      label: titles[index],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isWide ? 32 : 22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Designer! 👋',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ColorMate',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF29243B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFECE7FF),
                        child: Icon(
                          Icons.person_rounded,
                          color: Color(0xFF8065F6),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8065F6),
                          Color(0xFFB18CFF),
                          Color(0xFFFF9AB5),
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
                          'Create something beautiful ✨',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Explore colors, build palettes, and design '
                          'with better accessibility.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () => onNavigate(1),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF8065F6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 13,
                            ),
                          ),
                          child: const Text('Explore Colors'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    'What do you want to do?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29243B),
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: isWide ? 3 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: isWide ? 1.5 : 1.05,
                    children: [
                      FeatureTile(
                        title: 'Explore Colors',
                        subtitle: 'Discover new shades',
                        icon: Icons.palette_rounded,
                        color: const Color(0xFFFF8A9B),
                        onTap: () => onNavigate(1),
                      ),
                      FeatureTile(
                        title: 'My Collection',
                        subtitle: 'Save your palettes',
                        icon: Icons.bookmark_rounded,
                        color: const Color(0xFF70C9B0),
                        onTap: () => onNavigate(2),
                      ),
                      FeatureTile(
                        title: 'Contrast Checker',
                        subtitle: 'Check color readability',
                        icon: Icons.contrast_rounded,
                        color: const Color(0xFF8B78F6),
                        onTap: () => onNavigate(3),
                      ),
                      FeatureTile(
                        title: 'Color Generator',
                        subtitle: 'Create color palettes',
                        icon: Icons.auto_awesome_rounded,
                        color: const Color(0xFFFFB45E),
                        onTap: () => onNavigate(1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    'Color inspiration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29243B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      ColorDot(color: Color(0xFF8065F6)),
                      ColorDot(color: Color(0xFFFF8A9B)),
                      ColorDot(color: Color(0xFFFFC66E)),
                      ColorDot(color: Color(0xFF70C9B0)),
                      ColorDot(color: Color(0xFF77B8F5)),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 25),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
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

class ColorDot extends StatelessWidget {
  final Color color;

  const ColorDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 65,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class FeatureScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const FeatureScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(icon, size: 55, color: color),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
            const Text(
              'Coming soon ✨',
              style: TextStyle(
                color: Color(0xFF8065F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
