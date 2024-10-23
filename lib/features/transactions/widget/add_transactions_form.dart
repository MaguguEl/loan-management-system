import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/model/loan_model.dart';

class AddTransactionsForm extends StatefulWidget {
  final String memberId;

  const AddTransactionsForm({Key? key, required this.memberId}) : super(key: key);

  @override
  _AddTransactionsFormState createState() => _AddTransactionsFormState();
}

class _AddTransactionsFormState extends State<AddTransactionsForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedTransactionType;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.blue, 
          colorScheme: ColorScheme.light(primary: Colors.blue), 
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
    });
  }
}

  // Method to calculate interest based on the amount
  double _calculateInterest(double amount) {
    if (amount < 100000) {
      return 0.0; // No interest
    } else if (amount >= 100000 && amount < 1000000) {
      return amount * 0.05; // 5% interest
    } else if (amount >= 1000000 && amount < 3000000) {
      return amount * 0.10; // 10% interest
    } else if (amount >= 3000000) {
      return amount * 0.14; // 14% interest
    }
    return 0.0; // Default case
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
        double interest = _calculateInterest(amount);
        newLoan = Loan(
          id: loanId,
          loanAmount: amount + interest, // Store the total amount including interest
          loanPaid: 0.0,
          loanTaken: amount, // Store the amount taken as a loan
        );
      } else {
        newLoan = Loan(
          id: loanId,
          loanAmount: 0.0,
          loanPaid: amount, // Store the amount paid back
          loanTaken: 0.0,
        );
      }

      // Store the new loan in Firebase
      await memberRef.child(loanId).set(newLoan.toMap());

      // Clear form and go back
      _amountController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTransactionType = null;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0), // Focused border color
                        ),
                      ),
                      dropdownColor: Colors.white,
                      focusColor: Colors.white,
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
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'Select Date',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          
          // Submit Button at the bottom
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
    );
  }
}
