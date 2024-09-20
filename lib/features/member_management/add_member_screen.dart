import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/widget/add_member_form.dart';

class AddMembersScreen extends StatelessWidget {
  const AddMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddMemberForm(), 
      ),
    );
  }
}
