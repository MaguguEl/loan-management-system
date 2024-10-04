import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Loan {
  String id;
  double loanAmount;
  double loanPaid;
  double loanTaken;

  Loan({
    required this.id,
    required this.loanAmount,
    required this.loanPaid,
    required this.loanTaken,
  });

  factory Loan.fromMap(Map<dynamic, dynamic> map, String id) {
    return Loan(
      id: id,
      loanAmount: map['loanAmount'] ?? 0.0,
      loanPaid: map['loanPaid'] ?? 0.0,
      loanTaken: map['loanTaken'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loanAmount': loanAmount,
      'loanPaid': loanPaid,
      'loanTaken': loanTaken,
    };
  }
}

class AddTransactionsForm extends StatefulWidget {
  final String memberId; // The member's ID to store the transaction under

  const AddTransactionsForm({Key? key, required this.memberId}) : super(key: key);

  @override
  _AddTransactionsFormState createState() => _AddTransactionsFormState();
}

class _AddTransactionsFormState extends State<AddTransactionsForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedTransactionType; // For loan paid or loan taken
  DateTime? _selectedDate; // To store the selected date

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Method to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method to add a transaction (loan)
  Future<void> _addTransaction() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference memberRef = FirebaseDatabase.instance.ref('members/${widget.memberId}/loans');

      // Generate a unique ID for the loan
      String loanId = memberRef.push().key ?? '';
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      // Create a new Loan object based on the selected transaction type
      Loan newLoan;
      if (_selectedTransactionType == 'Loan Taken') {
        newLoan = Loan(id: loanId, loanAmount: amount, loanPaid: 0.0, loanTaken: amount);
      } else {
        newLoan = Loan(id: loanId, loanAmount: 0.0, loanPaid: amount, loanTaken: 0.0);
      }

      // Debugging logs
      print('Selected Transaction Type: $_selectedTransactionType');
      print('Entered Amount: $amount');

      // Store the new loan in Firebase
      await memberRef.child(loanId).set(newLoan.toMap());

      // Clear form and go back
      _amountController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTransactionType = null;
      });
      
      // Call refresh method (make sure to implement this in MemberDetailsScreen)
      Navigator.pop(context);
      // You may need to add a callback or a method in MemberDetailsScreen to refresh data
      // For example: MemberDetailsScreen.refreshLoanData(widget.memberId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTransactionType,
                hint: const Text('Select Transaction Type'),
                items: [
                  DropdownMenuItem(value: 'Loan Taken', child: Text('Loan Taken')),
                  DropdownMenuItem(value: 'Loan Paid', child: Text('Loan Paid')),
                ],
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
              const SizedBox(height: 16),

              // Amount Input Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextButton(
  onPressed: () => _selectDate(context),
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    side: const BorderSide(color: Colors.grey),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    backgroundColor: Colors.white, // Optional: change background color if needed
  ),
  child: Text(
    _selectedDate != null
        ? '${_selectedDate!.toLocal()}'.split(' ')[0]
        : 'Select Date',
    style: const TextStyle(fontSize: 16),
  ),
),

              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _addTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
