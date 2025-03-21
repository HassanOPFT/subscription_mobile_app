import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription_mobile_app/widgets/subscriptions_savings.dart';
import '../models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final formattedRenewalDate = DateFormat(
      'MMM dd, yyyy',
    ).format(subscription.renewalDate);

    final formattedPrice = NumberFormat.currency(
      symbol: '\ريال ',
    ).format(subscription.price);

    final daysUntilRenewal =
        subscription.renewalDate.difference(DateTime.now()).inDays;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12),
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
                Row(
                  children: [
                    Text(
                      subscription.billingCycle.capitalize(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      ' • Renews on ${DateFormat.yMMMd().format(subscription.renewalDate)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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
      renewalText = '${daysUntilRenewal.toString()} days';
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
