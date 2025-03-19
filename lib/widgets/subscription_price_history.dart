import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionPriceHistory extends StatelessWidget {
  final List<dynamic> priceHistory;
  final ColorScheme colorScheme;

  const SubscriptionPriceHistory({
    super.key,
    required this.priceHistory,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (priceHistory.isEmpty) {
      return Center(
        child: Text(
          'No price history available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final List<TableRow> rows = [];

    rows.add(
      TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Date',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Old Price',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'New Price',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    // Data rows
    for (final item in priceHistory) {
      final oldPrice = _parsePrice(item['old_price']);
      final newPrice = _parsePrice(item['new_price']);
      final changeDate = DateTime.parse(item['change_date']);
      final priceChange = newPrice - oldPrice;

      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  DateFormat('MMM d, yyyy').format(changeDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  NumberFormat.currency(symbol: '\ريال ').format(oldPrice),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      NumberFormat.currency(symbol: '\ريال ').format(newPrice),
                      style: TextStyle(
                        color:
                            priceChange > 0
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      priceChange > 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color:
                          priceChange > 0
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Table(children: rows);
  }

  double _parsePrice(dynamic price) {
    if (price is double) {
      return price;
    } else if (price is int) {
      return price.toDouble();
    } else if (price is String) {
      return double.parse(price);
    }
    return 0.0;
  }
}
