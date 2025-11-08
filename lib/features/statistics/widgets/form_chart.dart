import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';

class FormChart extends StatelessWidget {
  const FormChart({super.key, required this.matches});

  final List<Match> matches;

  @override
  Widget build(BuildContext context) {
    final chartData = matches.take(5).toList();
    final series = [
      charts.Series<Match, String>(
        id: 'Form',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (match, _) => match.date.day.toString(),
        measureFn: (match, _) => match.homeScore ?? 0,
        data: chartData,
      ),
    ];

    if (chartData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Form verisi bulunamadı.')),
      );
    }

    return SizedBox(
      height: 200,
      child: charts.BarChart(series, animate: true),
    );
  }
}
