import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/model/shares_model.dart';

class AddSharesForm extends StatefulWidget {
  final String memberId;

  const AddSharesForm({Key? key, required this.memberId}) : super(key: key);

  @override
  _AddSharesFormState createState() => _AddSharesFormState();
}

class _AddSharesFormState extends State<AddSharesForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Method to add shares
  Future<void> _addShares() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference memberRef = FirebaseDatabase.instance.ref('members/${widget.memberId}/shares');

      // Generate a unique ID for the share
      String sharesId = memberRef.push().key ?? '';
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      // Create a new Shares object (you might want to define a new model)
      Share newShares = Share(
        id: sharesId,
        amount: amount,
      );

      // Store the new shares in Firebase
      await memberRef.child(sharesId).set(newShares.toMap());

      // Clear form and go back
      _amountController.clear();
      Navigator.pop(context);
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
              // Amount Input Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  labelText: 'Shares Amount',
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shares amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _addShares,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Shares',
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
