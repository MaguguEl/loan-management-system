import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:loan_management_system/features/member_management/member_detail_screen.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';
class PenaltyScreen extends StatefulWidget {
  @override
  _PenaltyScreenState createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends State<PenaltyScreen> {
  final List<Member> members = [];
  String searchQuery = '';
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

   Color getColorForMember(String memberId) {
    int hash = memberId.hashCode;
    Random random = Random(hash);
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

   String _formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00'); 
    return formatter.format(number);
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
                Navigator.of(context).pop();
                // Implement delete logic here
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
    final filteredMembers = members.where((member) {
      return 
      member.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
      member.ward.contains(searchQuery);
    }).toList();
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
          'Penalty',
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
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    leading: CircleAvatar(
                      backgroundColor: getColorForMember(member.id),
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
                              'K${_formatNumber(member.totalPenalties)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Penalty',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailsScreen(
                            member: member,
                            memberId: member.id,
                          ),
                        ),
                      );
                    },
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
