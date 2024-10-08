import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/widget/add_dividends_form.dart';

class AddAccountScreen extends StatelessWidget {
  final String memberId;

  const AddAccountScreen({Key? key, required this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Dividends'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: AddAccountForm(memberId: memberId), // Pass memberId to form
      ),
    );
  }
}
