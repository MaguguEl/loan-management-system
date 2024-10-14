import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class DividendsScreen extends StatefulWidget {
  @override
  _DividendsScreenState createState() => _DividendsScreenState();
}

class _DividendsScreenState extends State<DividendsScreen> {
  final List<Member> members = [];
  final DatabaseReference _membersRef = FirebaseDatabase.instance.ref('members');

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    _membersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Member> loadedMembers = [];
        data.forEach((key, value) {
          loadedMembers.add(Member.fromMap(value, key));
        });

        setState(() {
          members.clear();
          members.addAll(loadedMembers);
        });
      }
    });
  }

  void _showDeleteConfirmationDialog(Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Member'),
          content: Text('Are you sure you want to delete ${member.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement delete logic
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Dividends',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: CircleAvatar(
                      //backgroundColor: getRandomColor(),
                      child: Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(member.name),
                    subtitle: Text('${member.ward}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'K${(member.totalDividends)}', 
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Dividends', 
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onLongPress: () => _showDeleteConfirmationDialog(member),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
