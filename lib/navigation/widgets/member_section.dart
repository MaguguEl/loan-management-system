import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class MemberSection extends StatefulWidget {
  const MemberSection({super.key});

  @override
  _MemberSectionState createState() => _MemberSectionState();
}

class _MemberSectionState extends State<MemberSection> {
  List<Member> members = []; 

  @override
  void initState() {
    super.initState();
    _fetchMembers(); 
  }

  Future<void> _fetchMembers() async {
    final DatabaseReference _database =
        FirebaseDatabase.instance.ref().child('members');

    DatabaseEvent snapshot = await _database.once();
    DataSnapshot dataSnapshot = snapshot.snapshot;
    Map<dynamic, dynamic>? memberData = dataSnapshot.value as Map<dynamic, dynamic>?;

    if (memberData != null) {
      members = memberData.entries
          .map((entry) {
            final memberMap = entry.value;
            return Member.fromMap(memberMap, entry.key as String);
          })
          .toList();

      if (members.length > 5) {
        members = members.sublist(0, 5);
      }
    }

    setState(() {});
  }

  Future<void> _deleteMember(String memberId) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members/$memberId');
    await dbRef.remove();
    setState(() {
      members.removeWhere((member) => member.id == memberId);
    });
  }

  Future<void> _showDeleteConfirmationDialog(Member member) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Member'),
          content: const Text('Are you sure you want to delete this member? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteMember(member.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Member List',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MembersScreen(),
                  ),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Column(
                children: [
                  MemberItem(
                    memberName: member.name, 
                    positiveAmount: 'K200', 
                    negativeAmount: 'K150', 
                    memberWard: member.ward, 
                    avatar: CircleAvatar(
                      backgroundColor: member.color, 
                      child: Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onDelete: () => _showDeleteConfirmationDialog(member),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class MemberItem extends StatelessWidget {
  final String memberName; 
  final String positiveAmount;
  final String negativeAmount;
  final String memberWard; 
  final Widget avatar;
  final VoidCallback onDelete; 

  const MemberItem({
    super.key,
    required this.memberName,
    required this.positiveAmount,
    required this.negativeAmount,
    required this.memberWard,
    required this.avatar,
    required this.onDelete, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: avatar,
        title: Text(
          memberName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          memberWard,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '+$positiveAmount',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              '-$negativeAmount',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
