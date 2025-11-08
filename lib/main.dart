import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/themes/app_theme.dart';
import 'shared/themes/dark_theme.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'features/matches/screens/matches_screen.dart';
import 'features/news/screens/news_screen.dart';
import 'features/squad/screens/squad_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
import 'features/fixture/screens/fixture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(const ProviderScope(child: AmedsporApp()));
}

class AmedsporApp extends ConsumerWidget {
  const AmedsporApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Amedspor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: DarkTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const _RootShell(),
    );
  }
}

class _RootShell extends StatefulWidget {
  const _RootShell();

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    MatchesScreen(),
    FixtureScreen(),
    SquadScreen(),
    StatisticsScreen(),
    NewsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amedspor'),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: AmedsporBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
