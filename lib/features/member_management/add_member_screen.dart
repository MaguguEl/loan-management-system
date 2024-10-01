import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/member_management/widget/add_member_form.dart';

class AddMembersScreen extends StatelessWidget {
  const AddMembersScreen({Key? key}) : super(key: key);

  void _onMemberAdded(BuildContext context) {
    // Navigate to MembersScreen after a member is added
    MaterialPageRoute(builder: (context) => const MembersScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AddMemberForm(onMemberAdded: () => _onMemberAdded(context)), // Pass the callback
      ),
    );
  }
}
