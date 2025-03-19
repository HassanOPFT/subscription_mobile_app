import 'package:flutter/material.dart';
import 'package:subscription_mobile_app/widgets/csv_upload.dart';

class CsvImportSubscriptionScreen extends StatelessWidget {
  static const routeName = '/csv-import-subscription';

  const CsvImportSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import from CSV')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Column(children: [CSVUploadForm()]),
      ),
    );
  }
}
