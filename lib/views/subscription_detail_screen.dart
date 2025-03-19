// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:subscription_mobile_app/modelview/subscription_view_model.dart';
import 'package:subscription_mobile_app/views/manage_subscription_screen.dart';
import 'package:subscription_mobile_app/views/subscriptions_screen.dart';
import 'package:subscription_mobile_app/widgets/subscription_price_history.dart';
import '../models/subscription_model.dart';

class SubscriptionDetailScreen extends ConsumerStatefulWidget {
  static const routeName = '/subscription-detail';
  final int subscriptionId;

  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  @override
  ConsumerState<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState
    extends ConsumerState<SubscriptionDetailScreen> {
  List<dynamic> _priceHistory = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPriceHistory();
  }

  Future<void> _loadPriceHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final history = await ref
          .read(subscriptionProvider.notifier)
          .getPriceHistory(widget.subscriptionId);

      setState(() {
        _priceHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final subscription = subscriptionState.when(
      data: (subscriptions) {
        return subscriptions.subscriptions.firstWhere(
          (sub) => sub.id == widget.subscriptionId,
          orElse:
              () => Subscription(
                id: -1,
                name: 'Unknown',
                price: 0,
                billingCycle: 'Unknown',
                renewalDate: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        );
      },
      loading:
          () => Subscription(
            id: -1,
            name: 'Loading...',
            price: 0,
            billingCycle: 'Unknown',
            renewalDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
      error:
          (err, stack) => Subscription(
            id: -1,
            name: 'Error loading subscription',
            price: 0,
            billingCycle: 'Unknown',
            renewalDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
    );

    void showSnackBar(String message, {bool isError = false}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    void showDeleteConfirmationDialog(
      BuildContext context,
      Subscription subscription,
    ) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('Delete ${subscription.name}?'),
              content: Text(
                'This action cannot be undone. Are you sure you want to delete this subscription?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    try {
                      Navigator.of(ctx).pop();
                      await ref
                          .read(subscriptionProvider.notifier)
                          .deleteSubscription(subscription.id);

                      context.go(SubscriptionsScreen.routeName);

                      showSnackBar('Subscription deleted successfully');
                    } catch (e) {
                      Navigator.of(ctx).pop();

                      showSnackBar(
                        'Failed to delete subscription',
                        isError: true,
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(subscription.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed:
                () => showDeleteConfirmationDialog(context, subscription),
          ),
        ],
      ),
      body:
          subscription.id == -1
              ? Center(
                child: Text(
                  'Subscription not found',
                  style: theme.textTheme.titleLarge,
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SubscriptionDetailCard(
                        subscription: subscription,
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Price History',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_error != null)
                        Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading price history',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadPriceHistory,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      else
                        SubscriptionPriceHistory(
                          priceHistory: _priceHistory,
                          colorScheme: colorScheme,
                        ),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(ManageSubscriptionScreen.routeName, extra: subscription);
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

class _SubscriptionDetailCard extends StatelessWidget {
  final Subscription subscription;
  final ColorScheme colorScheme;

  const _SubscriptionDetailCard({
    required this.subscription,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final formattedPrice = NumberFormat.currency(
      symbol: '\ريال ',
    ).format(subscription.price);

    final formattedRenewalDate = DateFormat(
      'MMMM dd, yyyy',
    ).format(subscription.renewalDate);

    final formattedCreatedAt = DateFormat(
      'MMMM dd, yyyy',
    ).format(subscription.createdAt);

    final formattedUpdatedAt = DateFormat(
      'MMMM dd, yyyy',
    ).format(subscription.updatedAt);

    final yearlyCost = _calculateYearlyCost(
      subscription.price,
      subscription.billingCycle,
    );
    final formattedYearlyCost = NumberFormat.currency(
      symbol: '\ ريال',
    ).format(yearlyCost);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        subscription.billingCycle,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    formattedPrice,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _DetailItem(
              icon: Icons.calendar_today,
              label: 'Next Renewal',
              value: formattedRenewalDate,
              colorScheme: colorScheme,
            ),
            const Divider(height: 24),

            _DetailItem(
              icon: Icons.savings,
              label: 'Yearly Cost',
              value: formattedYearlyCost,
              colorScheme: colorScheme,
            ),
            const Divider(height: 24),

            _DetailItem(
              icon: Icons.access_time,
              label: 'Created',
              value: formattedCreatedAt,
              colorScheme: colorScheme,
            ),
            const Divider(height: 24),

            _DetailItem(
              icon: Icons.update,
              label: 'Last Updated',
              value: formattedUpdatedAt,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateYearlyCost(double price, String billingCycle) {
    switch (billingCycle.toLowerCase()) {
      case 'monthly':
        return price * 12;

      case 'yearly':
        return price;

      default:
        return price * 12;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
