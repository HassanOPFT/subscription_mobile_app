// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_mobile_app/modelview/subscription_view_model.dart';
import 'package:subscription_mobile_app/models/subscription_model.dart';
import 'package:subscription_mobile_app/views/subscriptions_screen.dart';
import 'package:subscription_mobile_app/widgets/billing_cycle_dropdown.dart';

class SubscriptionForm extends ConsumerStatefulWidget {
  final Subscription? subscription;

  const SubscriptionForm({super.key, this.subscription});

  @override
  ConsumerState<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends ConsumerState<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late String _billingCycle;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.subscription?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.subscription?.price.toString() ?? '',
    );
    _billingCycle = widget.subscription?.billingCycle ?? 'monthly';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final subscriptionData = Subscription(
          id: widget.subscription?.id ?? 0,
          name: _nameController.text,
          price: double.parse(_priceController.text),
          billingCycle: _billingCycle,
          renewalDate:
              widget.subscription?.renewalDate ??
              DateTime.now().add(const Duration(days: 30)),
          createdAt: widget.subscription?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (widget.subscription == null) {
          await ref
              .read(subscriptionProvider.notifier)
              .createSubscription(
                name: subscriptionData.name,
                price: subscriptionData.price,
                billingCycle: _billingCycle,
              );

          _showSnackBar('Subscription created successfully');
        } else {
          await ref
              .read(subscriptionProvider.notifier)
              .updateSubscription(
                id: widget.subscription!.id,
                name: subscriptionData.name,
                price: subscriptionData.price,
                billingCycle: subscriptionData.billingCycle,
              );

          _showSnackBar('Subscription updated successfully');
        }

        context.go(SubscriptionsScreen.routeName);
      } catch (e) {
        debugPrint(e.toString());
        _showSnackBar(
          'Failed to ${widget.subscription == null ? 'create' : 'update'} subscription!',
          isError: true,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Subscription Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Subscription name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Price is required';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          BillingCycleDropdown(
            value: _billingCycle,
            onChanged:
                (cycle) => setState(() {
                  _billingCycle = cycle!;
                }),
          ),
          const SizedBox(height: 32),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FilledButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
