import 'package:flutter/material.dart';

class BillingCycleDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const BillingCycleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Billing Cycle',
      ),
      items: const [
        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
        DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
      ],
      onChanged: onChanged,
    );
  }
}
