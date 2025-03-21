import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_mobile_app/modelview/subscription_view_model.dart';
import 'package:subscription_mobile_app/views/subscription_detail_screen.dart';
import 'package:subscription_mobile_app/widgets/subscription_card.dart';
import 'package:subscription_mobile_app/widgets/subscription_card_skeleton.dart';
import 'package:subscription_mobile_app/widgets/subscriptions_cost_summary.dart';

class SubscriptionList extends ConsumerStatefulWidget {
  const SubscriptionList({super.key});

  @override
  ConsumerState<SubscriptionList> createState() =>
      _SubscriptionListWidgetState();
}

class _SubscriptionListWidgetState extends ConsumerState<SubscriptionList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(subscriptionProvider.notifier).loadSubscriptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);

    return subscriptionState.when(
      data: (subscriptions) {
        if (subscriptions.subscriptions.isEmpty) {
          return const Center(
            child: Text(
              'No subscriptions found. Add a subscription to get started.',
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SubscriptionCostSummary(
                  totalMonthlyAmount: subscriptions.totalMonthlyCost,
                  totalAnnualAmount: subscriptions.totalAnnualCost,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final subscription = subscriptions.subscriptions[index];

                return GestureDetector(
                  onTap: () {
                    context.push(
                      SubscriptionDetailScreen.routeName,
                      extra: subscription.id,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SubscriptionCard(subscription: subscription),
                  ),
                );
              }, childCount: subscriptions.subscriptions.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 70)),
          ],
        );
      },
      loading:
          () => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 7,
            itemBuilder:
                (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SubscriptionCardSkeleton(),
                ),
          ),
      error:
          (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading subscriptions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.read(subscriptionProvider.notifier).loadSubscriptions();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }
}
