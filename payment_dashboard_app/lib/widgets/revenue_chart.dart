import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueChart extends StatelessWidget {
  final List<double> revenueByDay; // Should be 7 data points for the last 7 days

  const RevenueChart({super.key, required this.revenueByDay});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final day = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                      return Text('${day.day}/${day.month}');
                    },
                    interval: 1,
                    reservedSize: 28,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 500),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: revenueByDay.asMap().entries.map(
                    (e) => FlSpot(e.key.toDouble(), e.value),
                  ).toList(),
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
