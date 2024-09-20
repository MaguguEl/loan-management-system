import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/widget/add_transactions_form.dart';
class AddTransactionsScreen extends StatelessWidget {
  const AddTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddTransactionsForm(),
      ),
    );
  }
}
