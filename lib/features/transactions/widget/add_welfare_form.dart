import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/model/welfare_model.dart';

class AddWelfareForm extends StatefulWidget {
  final String memberId;

  const AddWelfareForm({Key? key, required this.memberId}) : super(key: key);

  @override
  _AddWelfareFormState createState() => _AddWelfareFormState();
}

class _AddWelfareFormState extends State<AddWelfareForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Method to add welfare contribution
  Future<void> _addWelfare() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference memberRef = FirebaseDatabase.instance.ref('members/${widget.memberId}/welfare');

      // Generate a unique ID for the welfare contribution
      String welfareId = memberRef.push().key ?? '';
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      // Create a new Welfare object (you might want to define a new model)
      Welfare newWelfare = Welfare(
        id: welfareId,
        amount: amount,
      );

      // Store the new welfare contribution in Firebase
      await memberRef.child(welfareId).set(newWelfare.toMap());

      // Clear form and go back
      _amountController.clear();
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
                    // Amount Input Field
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: 'Welfare Amount',
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
                          return 'Please enter a welfare amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Submit Button
          ElevatedButton(
            onPressed: _addWelfare,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Welfare',
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