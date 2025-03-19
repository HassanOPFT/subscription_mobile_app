import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_mobile_app/views/manage_subscription_screen.dart';
import 'package:subscription_mobile_app/widgets/sub_manager_app_bar.dart';
import 'package:subscription_mobile_app/widgets/sub_manager_bottom_navigation_bar.dart';
import 'package:subscription_mobile_app/widgets/subscription_list.dart';

class SubscriptionsScreen extends ConsumerWidget {
  static const routeName = '/subscriptions';

  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SubManagerAppBar(title: 'Subscriptions'),
      body: const SubscriptionList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(ManageSubscriptionScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SubManagerBottomNavigationBar(currentIndex: 1),
    );
  }
}
