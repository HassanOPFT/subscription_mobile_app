import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PriceHistoryChart extends StatelessWidget {
  final List<dynamic> priceHistory;
  final ColorScheme colorScheme;

  const PriceHistoryChart({
    super.key,
    required this.priceHistory,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    // Process the price history data
    final List<FlSpot> spots = [];

    for (int i = 0; i < priceHistory.length; i++) {
      final item = priceHistory[i];
      final price = item['price'] as double;
      spots.add(FlSpot(i.toDouble(), price));
    }

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: colorScheme.onSurface.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: colorScheme.onSurface.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          NumberFormat.currency(symbol: '\$').format(value),
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      if (index >= 0 && index < priceHistory.length) {
                        final item = priceHistory[index];
                        final date = DateTime.parse(item['date']);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MMM dd').format(date),
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              minX: 0,
              maxX: priceHistory.length - 1.0,
              minY: _getMinY(spots),
              maxY: _getMaxY(spots),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.5),
                      colorScheme.primary,
                    ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0.3),
                        colorScheme.primary.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  // tooltipBgColor: colorScheme.surface,
                  tooltipRoundedRadius: 8,
                  tooltipBorder: BorderSide(
                    color: colorScheme.primary,
                    width: 1,
                  ),
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final index = barSpot.x.toInt();
                      if (index >= 0 && index < priceHistory.length) {
                        final item = priceHistory[index];
                        final date = DateTime.parse(item['date']);
                        final price = item['price'] as double;
                        return LineTooltipItem(
                          '${DateFormat('MMM dd, yyyy').format(date)}\n',
                          TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: NumberFormat.currency(
                                symbol: '\$',
                              ).format(price),
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                      return null;
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Price History',
              style: TextStyle(color: colorScheme.onSurface, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  double _getMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    return spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) * 0.9;
  }

  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    return spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.1;
  }
}
