import 'package:go_router/go_router.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';
import 'package:subscription_mobile_app/views/csv_import_subscription_screen.dart';
import 'package:subscription_mobile_app/views/dashboard_screen.dart';
import 'package:subscription_mobile_app/views/manage_subscription_screen.dart';
import 'package:subscription_mobile_app/views/subscription_detail_screen.dart';
import 'package:subscription_mobile_app/views/subscriptions_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: DashboardScreen.routeName,
  routes: [
    GoRoute(
      path: DashboardScreen.routeName,
      builder: (context, state) => DashboardScreen(),
    ),
    GoRoute(
      path: SubscriptionsScreen.routeName,
      builder: (context, state) => const SubscriptionsScreen(),
    ),
    GoRoute(
      path: ManageSubscriptionScreen.routeName,
      builder: (context, state) {
        final subscription = state.extra as Subscription?;
        return ManageSubscriptionScreen(subscription: subscription);
      },
    ),
    GoRoute(
      path: SubscriptionDetailScreen.routeName,
      builder: (context, state) {
        final subscriptionId = state.extra as int;
        return SubscriptionDetailScreen(subscriptionId: subscriptionId);
      },
    ),
    GoRoute(
      path: CsvImportSubscriptionScreen.routeName,
      builder: (context, state) {
        return CsvImportSubscriptionScreen();
      },
    ),
  ],
);
