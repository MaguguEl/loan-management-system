import 'package:flutter/material.dart';
import 'package:loan_management_system/features/reports/widget/data_table.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // Export report as PDF functionality
            },
          ),
        ],
      ),
      body: const ReportTableScreen(),
    );
  }
}

