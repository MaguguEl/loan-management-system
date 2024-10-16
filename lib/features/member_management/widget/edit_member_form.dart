import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';

class EditMemberForm extends StatefulWidget {
  final Function onMemberUpdated;
  final Member member;

  const EditMemberForm({Key? key, required this.onMemberUpdated, required this.member}) : super(key: key);

  @override
  _EditMemberFormState createState() => _EditMemberFormState();
}

class _EditMemberFormState extends State<EditMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('members');

  @override
  void initState() {
    super.initState();
    nameController.text = widget.member.name;
    phoneController.text = widget.member.phone;
    emailController.text = widget.member.email ?? '';
    wardController.text = widget.member.ward;
    noteController.text = widget.member.noteDescription ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    wardController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _updateMember() async {
    if (_formKey.currentState!.validate()) {
      // Create an updated member object, merging existing data with new values
      Member updatedMember = Member(
        id: widget.member.id, 
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text.isEmpty ? null : emailController.text,
        ward: wardController.text,
        noteDescription: noteController.text.isEmpty ? null : noteController.text,
        color: widget.member.color, 
        loans: widget.member.loans, 
        shares: widget.member.shares,
        dividends: widget.member.dividends,
        welfares: widget.member.welfares, 
        penalties: widget.member.penalties, 
      );

      // Update the member details in the Firebase database
      await _database.child(widget.member.id).set(updatedMember.toMap());

      widget.onMemberUpdated();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MembersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded( // Use Expanded to take up remaining space
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    _buildTextField('Name', nameController),
                    _buildTextField('Phone', phoneController, keyboardType: TextInputType.number),
                    _buildTextField('Email (Optional)', emailController, isOptional: true),
                    _buildTextField('Ward', wardController),
                    _buildTextField('Notes (Optional)', noteController, maxLines: 3, isOptional: true),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _updateMember,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Update Member',
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType, bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: label,
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
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null; // No error
        },
      ),
    );
  }
}