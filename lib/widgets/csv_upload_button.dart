import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subscription_mobile_app/views/csv_import_subscription_screen.dart';

class CSVUploadButton extends StatelessWidget {
  const CSVUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.push(CsvImportSubscriptionScreen.routeName);
      },
      label: Text('import from CSV', style: TextStyle(fontSize: 16)),
      icon: Icon(Icons.file_upload),
    );
  }
}
