import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Format the date
    final formattedRenewalDate = DateFormat(
      'MMM dd, yyyy',
    ).format(subscription.renewalDate);

    // Format the price with currency
    final formattedPrice = NumberFormat.currency(
      symbol: '\$',
    ).format(subscription.price);

    // Calculate days until renewal
    final daysUntilRenewal =
        subscription.renewalDate.difference(DateTime.now()).inDays;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subscription.name,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formattedPrice,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subscription.billingCycle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                _RenewalChip(
                  daysUntilRenewal: daysUntilRenewal,
                  renewalDate: formattedRenewalDate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RenewalChip extends StatelessWidget {
  final int daysUntilRenewal;
  final String renewalDate;

  const _RenewalChip({
    required this.daysUntilRenewal,
    required this.renewalDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color chipColor;
    String renewalText;

    if (daysUntilRenewal < 0) {
      chipColor = colorScheme.error;
      renewalText = 'Overdue';
    } else if (daysUntilRenewal <= 3) {
      chipColor = Colors.orange;
      renewalText = 'Due Soon';
    } else if (daysUntilRenewal <= 7) {
      chipColor = Colors.amber;
      renewalText = 'Next Week';
    } else {
      chipColor = colorScheme.secondary;
      renewalText = 'Upcoming';
    }

    return Tooltip(
      message: 'Renewal: $renewalDate',
      child: Chip(
        label: Text(renewalText),
        backgroundColor: chipColor.withOpacity(0.2),
        labelStyle: TextStyle(color: chipColor),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
