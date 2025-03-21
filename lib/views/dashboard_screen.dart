import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';
import 'package:subscription_mobile_app/modelview/subscription_view_model.dart';
import 'package:subscription_mobile_app/widgets/monthly_summary.dart';
import 'package:subscription_mobile_app/widgets/service_breakdown_card.dart';
import 'package:subscription_mobile_app/widgets/sub_manager_app_bar.dart';
import 'package:subscription_mobile_app/widgets/sub_manager_bottom_navigation_bar.dart';
import 'package:subscription_mobile_app/widgets/subscriptions_savings.dart';
import 'package:subscription_mobile_app/widgets/upcoming_renewals_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(subscriptionProvider.notifier).loadSubscriptions(),
    );
  }

  double calculateTotalMonthlyCost(List<Subscription> subscriptions) {
    return subscriptions
        .map((sub) => sub.price)
        .fold(0, (sum, price) => sum + price);
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionsAsyncValue = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: SubManagerAppBar(title: 'SubManager'),
      body: subscriptionsAsyncValue.when(
        loading: () => _buildLoadingUI(),
        error: (error, stackTrace) => _buildErrorUI(error),
        data: (subscriptionsData) {
          final totalMonthlyCost = calculateTotalMonthlyCost(
            subscriptionsData.subscriptions,
          );

          final subscriptions = subscriptionsData.subscriptions;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MonthlySummaryCard(
                  subscriptions: subscriptions,
                  totalMonthlyCost: totalMonthlyCost,
                ),
              ),
              SliverToBoxAdapter(
                child: ServiceBreakdownCard(subscriptions: subscriptions),
              ),

              SliverToBoxAdapter(
                child: UpcomingRenewalsCard(subscriptions: subscriptions),
              ),

              SliverToBoxAdapter(
                child: SubscriptionsSavings(subscriptions: subscriptions),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SubManagerBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildLoadingUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading subscriptions...'),
        ],
      ),
    );
  }

  Widget _buildErrorUI(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            'Error loading subscriptions: ${error.toString()}',
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
    );
  }
}
