import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';

class MonthlySummaryCard extends StatelessWidget {
  final List<Subscription> subscriptions;
  final double totalMonthlyCost;

  const MonthlySummaryCard({
    super.key,
    required this.subscriptions,
    required this.totalMonthlyCost,
  });

  @override
  Widget build(BuildContext context) {
    final renewalDates =
        subscriptions.map((sub) {
            final renewalDate = DateTime.parse(
              sub.renewalDate.toIso8601String(),
            );
            return {
              'service': sub.name,
              'date': DateFormat('MMM d').format(renewalDate),
              'amount': sub.price,
              'timestamp': renewalDate.millisecondsSinceEpoch,
            };
          }).toList()
          ..sort(
            (a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int),
          );

    final upcomingRenewals = renewalDates.take(7).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      totalMonthlyCost.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'ريال',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 0.5),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: const Text(
                      'Upcoming Renewals',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                if (upcomingRenewals.isEmpty)
                  const Text(
                    'No upcoming renewals found',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children:
                        upcomingRenewals
                            .map(
                              (item) => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item['service']} on ${item['date']}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '${(item['amount'] as double).toStringAsFixed(2)} ريال',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 8),
                                ],
                              ),
                            )
                            .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
