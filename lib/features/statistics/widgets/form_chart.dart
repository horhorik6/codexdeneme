import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FormChart extends StatelessWidget {
  const FormChart({super.key, required this.form});

  final List<String> form;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (var i = 0; i < form.length; i++) {
      final value = switch (form[i]) {
        'W' => 3,
        'D' => 1,
        _ => 0,
      };
      spots.add(FlSpot(i.toDouble(), value.toDouble()));
    }

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: Theme.of(context).colorScheme.primary,
              isCurved: true,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('#${value.toInt() + 1}'),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('M');
                    case 1:
                      return const Text('B');
                    case 3:
                      return const Text('G');
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
