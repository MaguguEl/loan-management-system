import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';

class AddMemberForm extends StatefulWidget {
  final Function onMemberAdded;

  const AddMemberForm({Key? key, required this.onMemberAdded}) : super(key: key);

  @override
  _AddMemberFormState createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController sharesController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('members');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    wardController.dispose();
    sharesController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    if (_formKey.currentState!.validate()) {
      Color randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

      Member newMember = Member(
        id: '',
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        ward: wardController.text,
        shares: sharesController.text,
        noteDescription: noteController.text,
        color: randomColor,
      );

      var newMemberRef = _database.push(); 
      await newMemberRef.set(newMember.toMap());
      newMember.id = newMemberRef.key ?? '';

      widget.onMemberAdded();

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create a new member',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField('Name', nameController),
              _buildTextField('Phone', phoneController, keyboardType: TextInputType.number,),
              _buildTextField('Email (Optional)', emailController),
              _buildTextField('Ward', wardController),
              _buildTextField('Shares', sharesController, keyboardType: TextInputType.number,),
              _buildTextField('Notes (Optional)', noteController, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Member',
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType}) {
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
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
