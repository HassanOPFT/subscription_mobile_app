import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscription_mobile_app/widgets/subscription_list.dart';

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SubManager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add subscription screen
              // You can implement this later
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              // Implement bulk import functionality
              // You can implement this later
            },
          ),
        ],
      ),
      body: const SubscriptionListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add subscription screen
          // You can implement this later
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
