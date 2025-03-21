import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';

class SubscriptionsSavings extends StatelessWidget {
  final List<Subscription> subscriptions;

  const SubscriptionsSavings({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return Center(
        child: Text(
          'No subscriptions available',
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
                'Subscription Details',
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
                'Actions',
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
    for (final subscription in subscriptions) {
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          NumberFormat.currency(
                            symbol: 'ريال ',
                          ).format(subscription.price),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '• ${subscription.billingCycle.capitalize()}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Renews on ${DateFormat.yMMMd().format(subscription.renewalDate)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action cell
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton.icon(
                  icon: const Icon(Icons.compare_arrows),
                  label: const Text('Compare Pricing'),
                  onPressed: () {
                    _showComparisonModal(context, subscription);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Annual/Monthly Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              // border: TableBorder.all(
              //   color: Theme.of(context).dividerColor.withOpacity(0.3),
              //   width: 1,
              // ),
              children: rows,
            ),
          ],
        ),
      ),
    );
  }

  void _showComparisonModal(BuildContext context, Subscription subscription) {
    showDialog(
      context: context,
      builder: (context) => ComparisonModal(subscription: subscription),
    );
  }
}

class ComparisonModal extends StatefulWidget {
  final Subscription subscription;

  const ComparisonModal({super.key, required this.subscription});

  @override
  State<ComparisonModal> createState() => _ComparisonModalState();
}

class _ComparisonModalState extends State<ComparisonModal> {
  final _formKey = GlobalKey<FormState>();
  final _alternativePriceController = TextEditingController();
  String? _error;
  Comparison? _comparison;

  @override
  void dispose() {
    _alternativePriceController.dispose();
    super.dispose();
  }

  void _handleCompare() {
    if (!_formKey.currentState!.validate()) return;

    final alternativePrice = double.tryParse(_alternativePriceController.text);

    if (alternativePrice == null || alternativePrice <= 0) {
      setState(() {
        _error = 'Please enter a valid price';
      });
      return;
    }

    final currentPrice = widget.subscription.price;
    final isMonthly = widget.subscription.billingCycle == 'monthly';

    // Calculate annual costs for both current and alternative pricing
    final currentAnnualCost = isMonthly ? currentPrice * 12 : currentPrice;
    final alternativeAnnualCost =
        isMonthly ? alternativePrice : alternativePrice * 12;

    // Calculate absolute difference in cost
    final absoluteDifference =
        (currentAnnualCost - alternativeAnnualCost).abs();

    // Determine which option is cheaper
    final isCurrentCheaper = currentAnnualCost < alternativeAnnualCost;

    setState(() {
      _comparison = Comparison(
        currentAnnualCost: currentAnnualCost,
        alternativeAnnualCost: alternativeAnnualCost,
        savings: absoluteDifference,
        isCurrentCheaper: isCurrentCheaper,
      );
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMonthly = widget.subscription.billingCycle == 'monthly';
    final alternativeCycle = isMonthly ? 'Yearly' : 'Monthly';
    final currentCycle = isMonthly ? 'Monthly' : 'Yearly';

    return AlertDialog(
      title: Text('Compare ${widget.subscription.name} Pricing'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(text: 'Current billing: '),
                  TextSpan(
                    text: currentCycle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' at '),
                  TextSpan(
                    text:
                        '${NumberFormat.currency(symbol: 'ريال ').format(widget.subscription.price)}/${isMonthly ? 'month' : 'year'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _alternativePriceController,
                    decoration: InputDecoration(
                      labelText: '$alternativeCycle Price (ريال)',
                      hintText: 'Enter $alternativeCycle price',
                      errorText: _error,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _handleCompare,
                    child: const Text('Calculate Savings'),
                  ),
                ],
              ),
            ),
            if (_comparison != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_comparison!.isCurrentCheaper)
                      Text(
                        'Your current $currentCycle plan is cheaper by ${NumberFormat.currency(symbol: 'ريال ').format(_comparison!.savings)}/year.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    else if (_comparison!.savings == 0)
                      const Text(
                        'There\'s no difference in cost between Monthly and Annual billing.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        'Switching to $alternativeCycle will save you ${NumberFormat.currency(symbol: 'ريال ').format(_comparison!.savings)}/year.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Current $currentCycle plan (yearly total): ${NumberFormat.currency(symbol: 'ريال ').format(_comparison!.currentAnnualCost)}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Alternative $alternativeCycle plan (yearly total): ${NumberFormat.currency(symbol: 'ريال ').format(_comparison!.alternativeAnnualCost)}',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class Comparison {
  final double currentAnnualCost;
  final double alternativeAnnualCost;
  final double savings;
  final bool isCurrentCheaper;

  Comparison({
    required this.currentAnnualCost,
    required this.alternativeAnnualCost,
    required this.savings,
    required this.isCurrentCheaper,
  });
}

// Add this extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
