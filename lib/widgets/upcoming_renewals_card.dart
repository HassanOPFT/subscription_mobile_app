import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';

class UpcomingRenewalsCard extends StatelessWidget {
  final List<Subscription> subscriptions;

  const UpcomingRenewalsCard({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    int calculateDaysLeft(DateTime renewalDate) {
      final difference = renewalDate.difference(today);
      return difference.inDays;
    }

    final upcomingRenewals =
        subscriptions
            .map((sub) {
              final renewalDate = DateTime.parse(
                sub.renewalDate.toIso8601String(),
              );
              final daysLeft = calculateDaysLeft(renewalDate);

              return {
                'service': sub.name,
                'date': DateFormat('MMM d').format(renewalDate),
                'amount': sub.price,
                'daysLeft': daysLeft,
                'renewalDate': renewalDate,
              };
            })
            .where(
              (item) =>
                  (item['daysLeft'] as int) > 0 &&
                  (item['daysLeft'] as int) <= 7,
            )
            .toList()
          ..sort(
            (a, b) => (a['daysLeft'] as int).compareTo(b['daysLeft'] as int),
          );

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Renewals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                upcomingRenewals.isEmpty
                    ? const Text(
                      'No upcoming renewals in the next 7 days.',
                      style: TextStyle(color: Colors.grey),
                    )
                    : Column(
                      children:
                          upcomingRenewals.map((item) {
                            final daysLeft = item['daysLeft'] as int;
                            final isUrgent = daysLeft < 3;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isUrgent
                                          ? Colors.red.shade200
                                          : Colors.grey.shade300,
                                ),
                                color:
                                    isUrgent
                                        ? Colors.red.shade50
                                        : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (isUrgent)
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      if (isUrgent) const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['service'] as String,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                item['date'] as String,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color:
                                                      isUrgent
                                                          ? Colors.red
                                                          : Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                ),
                                                child: Text(
                                                  '$daysLeft days left',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${(item['amount'] as double).toStringAsFixed(2)} ريال',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
          ),
        ],
      ),
    );
  }
}
