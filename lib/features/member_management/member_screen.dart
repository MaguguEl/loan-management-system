import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/member_detail_screen.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Member> members = [];
  String searchQuery = '';
  String sortingCriteria = 'Name';
  String? selectedWard;

  @override
  void initState() {
    super.initState();
    _loadMembersFromDatabase();
  }

  Future<void> _loadMembersFromDatabase() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members');
    DatabaseEvent event = await dbRef.once();
    members.clear();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        members.add(Member.fromMap(value, key)); 
      });
    }

    setState(() {});
  }

  Future<void> _showMemberOptions(BuildContext context, Member member) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Member'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to member detail screen to edit
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MemberDetailScreen(member: member),
                //   ),
                // ).then((_) {
                //   _loadMembersFromDatabase(); // Refresh the member list after editing
                // });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Member'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(member);
              },
            ),
          ],
        );
      },
    );
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

  Future<void> _deleteMember(String memberId) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members/$memberId');
    await dbRef.remove();
    setState(() {
      members.removeWhere((member) => member.id == memberId);
    });
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = members.where((member) {
      final matchesSearch = member.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member.phone.contains(searchQuery);
      final matchesWard = selectedWard == null || member.ward == selectedWard;
      return matchesSearch && matchesWard;
    }).toList();

    filteredMembers.sort((a, b) {
      switch (sortingCriteria) {
        case 'Name':
          return a.name.compareTo(b.name);
        case 'Phone':
          return a.phone.compareTo(b.phone);
        case 'Ward':
          return a.ward.compareTo(b.ward);
        default:
          return 0;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // You can implement sorting or filtering options here if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Members',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      leading: CircleAvatar(
                        backgroundColor: getRandomColor(), // Generates a random color
                        child: Text(
                          member.name.isNotEmpty ? member.name[0].toUpperCase() : '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(member.name),
                      subtitle: Text('${member.phone} | ${member.ward}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '+150',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '-200',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              _showMemberOptions(context, member);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigating to MemberDetailsScreen with member details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberDetailsScreen(
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
                      onLongPress: () => _showMemberOptions(context, member),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
