import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:subscription_mobile_app/models/subscription_model.dart';

class ServiceBreakdownCard extends StatelessWidget {
  final List<Subscription> subscriptions;

  const ServiceBreakdownCard({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Service Subscription Costs Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: SubscriptionBarChart(subscriptions: subscriptions),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionBarChart extends StatelessWidget {
  final List<Subscription> subscriptions;

  const SubscriptionBarChart({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return Center(
        child: Text(
          'No subscription data available',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    }

    final sortedSubscriptions = List<Subscription>.from(subscriptions)
      ..sort((a, b) => b.price.compareTo(a.price));

    final maxPrice = sortedSubscriptions
        .map((e) => e.price)
        .reduce((a, b) => a > b ? a : b);

    final chartMaxY = maxPrice * 1.2;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: math.max(
          MediaQuery.of(context).size.width - 32,
          sortedSubscriptions.length * 30.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            isVisible: true,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
            labelRotation: 90,
            labelPlacement: LabelPlacement.onTicks,
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            isVisible: true,
            maximum: chartMaxY,
            labelFormat: '{value}',
            axisLine: const AxisLine(width: 0),
          ),
          series: <CartesianSeries>[
            _createBarSeries(context, sortedSubscriptions),
          ],
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'point.y ريال',
          ),
        ),
      ),
    );
  }

  ColumnSeries<Subscription, String> _createBarSeries(
    BuildContext context,
    List<Subscription> sortedSubscriptions,
  ) {
    return ColumnSeries<Subscription, String>(
      dataSource: sortedSubscriptions,
      xValueMapper:
          (Subscription subscription, _) => _formatName(subscription.name),
      yValueMapper: (Subscription subscription, _) => subscription.price,
      name: 'Subscription Cost',
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      width: 0.9,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.outside,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
        labelAlignment: ChartDataLabelAlignment.outer,
        angle: 270,
      ),
    );
  }

  String _formatName(String name) {
    if (name.length > 15) {
      return '${name.substring(0, 12)}...';
    }
    return name;
  }
}

class SubscriptionChartData {
  final String name;
  final double price;
  final Color color;

  SubscriptionChartData(this.name, this.price, this.color);
}
