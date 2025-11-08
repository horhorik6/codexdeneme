import 'package:flutter/material.dart';
class AmedBottomNavBar extends StatelessWidget {
  const AmedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationBar(
          height: 72,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Ana Sayfa'),
            NavigationDestination(icon: Icon(Icons.sports_soccer), label: 'Maçlar'),
            NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Fikstür'),
            NavigationDestination(icon: Icon(Icons.group_outlined), label: 'Kadro'),
            NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'İstatistik'),
            NavigationDestination(icon: Icon(Icons.article_outlined), label: 'Haberler'),
          ],
        ),
      ),
    );
  }
}
