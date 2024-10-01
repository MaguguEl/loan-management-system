import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:loan_management_system/features/member_management/model/member_model.dart';
import 'package:loan_management_system/features/member_management/widget/add_member_form.dart';

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

  void _loadMembersFromDatabase() async {
    // Fetch members from Firebase
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members');
    
    // Fetch data as a DatabaseEvent
    DatabaseEvent event = await dbRef.once();
    
    // Clear current members
    members.clear();

    // Parse the data from Firebase
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        members.add(Member.fromMap(value, key)); // Use your Member model's fromMap method
      });
    }

    setState(() {
      // Refresh the state to show the updated list
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
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMemberForm(onMemberAdded: _loadMembersFromDatabase),
                ),
              );
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
            DropdownButton<String>(
              value: sortingCriteria,
              onChanged: (newValue) {
                setState(() {
                  sortingCriteria = newValue!;
                });
              },
              items: <String>['Name', 'Phone', 'Ward'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Sort by $value'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getRandomColor(),
                      child: Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(member.name),
                    subtitle: Text('${member.phone} | ${member.ward}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await FirebaseDatabase.instance
                            .ref('members/${member.id}') // Assuming `member.id` is the key
                            .remove(); // Delete member from Firebase
                        _loadMembersFromDatabase(); // Refresh list after deletion
                      },
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
