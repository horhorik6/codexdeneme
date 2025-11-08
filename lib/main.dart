import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'shared/themes/app_theme.dart';
import 'shared/themes/dark_theme.dart';
import 'core/services/supabase_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/matches/screens/matches_screen.dart';
import 'features/squad/screens/squad_screen.dart';
import 'features/news/screens/news_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
import 'features/fixture/screens/fixture_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: AmedsporApp()));
}

class AmedsporApp extends ConsumerWidget {
  const AmedsporApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Amedspor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: DarkTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
      ],
      home: const _RootNavigationShell(),
    );
  }
}

class _RootNavigationShell extends ConsumerStatefulWidget {
  const _RootNavigationShell();

  @override
  ConsumerState<_RootNavigationShell> createState() => _RootNavigationShellState();
}

class _RootNavigationShellState extends ConsumerState<_RootNavigationShell> {
  int _selectedIndex = 0;

  final _screens = const [
    HomeScreen(),
    MatchesScreen(),
    FixtureScreen(),
    SquadScreen(),
    StatisticsScreen(),
    NewsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: AmedBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void toggleTheme(ThemeMode mode) => state = mode;
}
