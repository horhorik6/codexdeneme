import 'package:flutter/material.dart';

class AmedsporBottomNavBar extends StatelessWidget {
  const AmedsporBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Maçlar'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Fikstür'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Kadro'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'İstatistik'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Haberler'),
      ],
    );
  }
}
