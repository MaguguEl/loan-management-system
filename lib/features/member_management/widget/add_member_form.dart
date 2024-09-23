import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/member_list_screen.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm({Key? key}) : super(key: key);

  @override
  _AddMemberFormState createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();
  final TextEditingController sharesController = TextEditingController();
  final TextEditingController welfareController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    residenceController.dispose();
    sharesController.dispose();
    welfareController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
     // color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Create a new member',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField('Name', nameController),
              _buildTextField('Phone', phoneController),
              _buildTextField('Residence', residenceController),
              _buildTextField('Shares', sharesController),
              _buildTextField('Welfare', welfareController),
              _buildTextField('Type a note...', noteController, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                // onPressed: () {
                //   if (_formKey.currentState!.validate()) {
                //     // Handle save action
                //     print('Member saved');
                //   }
                // },
                  // Handle the planting data here, instead of saving to the database.
                  onPressed: () async {
                  
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MembersScreen(
                      memberName: nameController.text,
                    memberPhone: phoneController.text,
                    memberResidence: residenceController.text,
                    memberWelfare: welfareController.text,
                    noteDescription: noteController.text,
                    );
                  }),
                );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                ),
                child: Text(
                  'Save member',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                ),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey), 
          floatingLabelStyle: TextStyle(color: Colors.blueAccent), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          filled: true,
          fillColor: Colors.transparent, 
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (label != 'Penalty (optional)') {
              return 'Please enter $label';
            }
          }
          return null;
        },
      ),
    );
  }
}
