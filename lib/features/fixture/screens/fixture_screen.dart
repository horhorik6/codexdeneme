import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';
import '../widgets/fixture_card.dart';

class FixtureScreen extends StatelessWidget {
  const FixtureScreen({super.key});

  final List<Match> fixture = const [];

  @override
  Widget build(BuildContext context) {
    if (fixture.isEmpty) {
      return const Center(child: Text('Fikstür bilgisi bulunamadı.'));
    }

    return ListView.builder(
      itemCount: fixture.length,
      itemBuilder: (context, index) => FixtureCard(match: fixture[index]),
    );
  }
}
