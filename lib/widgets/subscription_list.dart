import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscription_mobile_app/modelview/subscription_view_model.dart';
import 'package:subscription_mobile_app/views/subscription_detail_screen.dart';
import 'package:subscription_mobile_app/widgets/subscription_card.dart';
import 'package:subscription_mobile_app/widgets/subscription_card_skeleton.dart';

class SubscriptionListWidget extends ConsumerStatefulWidget {
  const SubscriptionListWidget({super.key});

  @override
  ConsumerState<SubscriptionListWidget> createState() =>
      _SubscriptionListWidgetState();
}

class _SubscriptionListWidgetState
    extends ConsumerState<SubscriptionListWidget> {
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
        if (subscriptions.isEmpty) {
          return const Center(
            child: Text(
              'No subscriptions found. Add a subscription to get started.',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            final subscription = subscriptions[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SubscriptionDetailScreen(
                          subscriptionId: subscription.id,
                        ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SubscriptionCard(subscription: subscription),
              ),
            );
          },
        );
      },
      loading:
          () => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5, // Show 5 skeleton items while loading
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
                ElevatedButton(
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
