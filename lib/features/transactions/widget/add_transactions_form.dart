import 'package:flutter/material.dart';

class AddTransactionsForm extends StatefulWidget {
  const AddTransactionsForm({super.key});

  @override
  _AddTransactionsFormState createState() => _AddTransactionsFormState();
}

class _AddTransactionsFormState extends State<AddTransactionsForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _penaltyController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedTransactionType;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _amountController.dispose();
    _penaltyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adjust elevation as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true, // Prevent the ListView from expanding indefinitely
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                        : 'Select Date',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedTransactionType,
                items: ['Loan Taken', 'Loan Paid'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a transaction type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Amount TextField
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Penalty TextField
              TextFormField(
                controller: _penaltyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Penalty fee (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return null; // Allow empty input
                },
              ),
              const SizedBox(height: 20),

              // Description TextField
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission logic here
                    print('Form Submitted');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                ),
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                ),)
                ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
