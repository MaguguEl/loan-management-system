import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/member_detail_screen.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class MemberSection extends StatefulWidget {
  const MemberSection({super.key});

  @override
  _MemberSectionState createState() => _MemberSectionState();
}

class _MemberSectionState extends State<MemberSection> {
  List<Member> members = [];
  bool isLoading = true; // Used to track loading state

  @override
  void initState() {
    super.initState();
    _loadMembersFromDatabase(); // Load members when the widget is initialized
  }

  Future<void> _loadMembersFromDatabase() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members');
    DatabaseEvent event = await dbRef.once();

    members.clear(); // Clear the existing members list
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        members.add(Member.fromMap(value, key));
      });
    }

    setState(() {
      isLoading = false; // Set loading to false once the data is fetched
    });
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
            const Text(
              'Member List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembersScreen(),
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
        
        isLoading 
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), 
              ),
            )
          : Expanded(
              child: ListView.builder(
                itemCount: members.length > 5 ? 5 : members.length, // Limit to 5 members
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Column(
                    children: [
                      MemberItem(
                        member: member, // Pass the full member object
                        memberName: member.name, 
                        positiveAmount: member.loans.fold<double>(0, (sum, loan) => sum + loan.loanPaid).toStringAsFixed(2), // Dynamically calculate positive amount
                        negativeAmount: member.loans.fold<double>(0, (sum, loan) => sum + loan.loanTaken).toStringAsFixed(2), // Dynamically calculate negative amount
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
  final Member member; // Member object is added here

  const MemberItem({
    super.key,
    required this.memberName,
    required this.positiveAmount,
    required this.negativeAmount,
    required this.memberWard,
    required this.avatar,
    required this.onDelete,
    required this.member, // Member object is passed here
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberDetailsScreen(
                memberId: member.id, // Pass the memberId
                memberName: member.name,
                memberPhone: member.phone,
                memberEmail: member.email ?? 'No email',
                memberWard: member.ward,
                memberShares: member.shares.toString(),
                noteDescription: member.noteDescription ?? 'No description',
              ),
            ),
          );
        },
      ),
    );
  }
}
