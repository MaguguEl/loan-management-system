import 'package:flutter/material.dart';

class AddTransactionsScreen extends StatelessWidget {
  const AddTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('Add Trans Content'),
      ),
    );
  }
}