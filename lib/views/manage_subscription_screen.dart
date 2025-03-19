import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscription_mobile_app/widgets/csv_upload_button.dart';
import 'package:subscription_mobile_app/widgets/or_divider.dart';
import 'package:subscription_mobile_app/widgets/subscription_form.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';

class ManageSubscriptionScreen extends ConsumerWidget {
  static const routeName = '/manage-subscription';

  final Subscription? subscription;

  const ManageSubscriptionScreen({super.key, this.subscription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = subscription != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Subscription' : 'Add Subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SubscriptionForm(subscription: subscription),
              if (!isEditing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: OrDivider(),
                ),
              if (!isEditing) const CSVUploadButton(),
            ],
          ),
        ),
      ),
    );
  }
}
