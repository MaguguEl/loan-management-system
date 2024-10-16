import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/member_management/widget/edit_member_form.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class EditMemberScreen extends StatelessWidget {
  final Member member; // The member to be edited

  const EditMemberScreen({Key? key, required this.member}) : super(key: key);

  void _onMemberUpdated(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MembersScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Member'),
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
        child: EditMemberForm(
          onMemberUpdated: () => _onMemberUpdated(context),
          member: member, 
        ),
      ),
    );
  }
}
