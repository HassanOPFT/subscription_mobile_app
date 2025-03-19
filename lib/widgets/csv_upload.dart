import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:subscription_mobile_app/modelview/subscription_view_model.dart';
import 'package:subscription_mobile_app/views/subscriptions_screen.dart';

class CSVUploadForm extends ConsumerStatefulWidget {
  const CSVUploadForm({super.key});

  @override
  ConsumerState<CSVUploadForm> createState() => _CSVUploadFormState();
}

class _CSVUploadFormState extends ConsumerState<CSVUploadForm> {
  PlatformFile? _file;
  String? _error;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    setState(() {
      _error = null;
    });

    if (result == null || result.files.isEmpty) {
      setState(() {
        _file = null;
      });
      return;
    }

    final selectedFile = result.files.first;

    if (!selectedFile.name.toLowerCase().endsWith('.csv')) {
      setState(() {
        _error = "Please upload a CSV file";
        _file = null;
      });
      return;
    }

    if (selectedFile.size > 5 * 1024 * 1024) {
      setState(() {
        _error = "File size should not exceed 5MB";
        _file = null;
      });
      return;
    }

    setState(() {
      _file = selectedFile;
    });
  }

  Future<void> _handleSubmit() async {
    if (_file == null) {
      setState(() {
        _error = "Please select a file to upload";
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      http.MultipartFile? multipartFile;

      if (_file!.bytes != null) {
        multipartFile = http.MultipartFile.fromBytes(
          'file',
          _file!.bytes!,
          filename: _file!.name,
        );
      } else if (_file!.path != null) {
        final file = File(_file!.path!);
        final bytes = await file.readAsBytes();
        multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: _file!.name,
        );
      } else {
        throw Exception("Cannot read file: both bytes and path are null");
      }

      await ref
          .read(subscriptionProvider.notifier)
          .bulkCreateSubscription(multipartFile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscriptions imported successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        context.go(SubscriptionsScreen.routeName);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing subscriptions: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearFile() {
    setState(() {
      _file = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Import from CSV',
              style: TextStyle(fontSize: theme.textTheme.titleLarge?.fontSize),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CSV Format Instructions:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInstructionItem('The CSV file must have a header row'),
                  _buildInstructionItem(
                    'Required columns: name, price, billing_cycle',
                  ),
                  _buildInstructionItem(
                    'The billing_cycle must be either monthly or yearly',
                  ),
                  _buildInstructionItem('The price must be a valid number'),
                  const SizedBox(height: 8),
                  Text(
                    'Example:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'name,price,billing_cycle\nNetflix,45.99,monthly\nAmazon Prime,199.99,yearly',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _isLoading ? null : _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _file == null
                        ? GestureDetector(
                          onTap: _pickFile,
                          child: Column(
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 32,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Drag and drop your CSV file here or',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _isLoading ? null : _pickFile,
                                child: const Text('Browse Files'),
                              ),
                            ],
                          ),
                        )
                        : Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _file!.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${(_file!.size / 1024).toStringAsFixed(1)} KB)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: theme.colorScheme.error,
                                onPressed: _clearFile,
                                iconSize: 20,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 32),
            FilledButton(
              onPressed: (_isLoading || _file == null) ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child:
                  _isLoading
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Uploading...'),
                        ],
                      )
                      : const Text('Submit'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        context.pop();
                      },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
