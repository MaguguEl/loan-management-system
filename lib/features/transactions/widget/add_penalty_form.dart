import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/model/penalty_model.dart';


class AddPenaltyForm extends StatefulWidget {
  final String memberId;

  const AddPenaltyForm({Key? key, required this.memberId}) : super(key: key);

  @override
  _AddPenaltyFormState createState() => _AddPenaltyFormState();
}

class _AddPenaltyFormState extends State<AddPenaltyForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Method to add penalty
  Future<void> _addPenalty() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference memberRef = FirebaseDatabase.instance.ref('members/${widget.memberId}/penalties');

      // Generate a unique ID for the penalty
      String penaltyId = memberRef.push().key ?? '';
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      // Create a new Penalty object (you might want to define a new model)
      Penalty newPenalty = Penalty(
        id: penaltyId,
        amount: amount,
      );

      // Store the new penalty in Firebase
      await memberRef.child(penaltyId).set(newPenalty.toMap());

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
                        labelText: 'Penalty Amount',
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
                          return 'Please enter a penalty amount';
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
            onPressed: _addPenalty,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Penalty',
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