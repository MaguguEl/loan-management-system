import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:loan_management_system/features/member_management/edit_member_screen.dart';
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
  bool isLoading = true;
  String sortBy = 'name';
  bool isAscending = true;
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _loadMembersFromDatabase();
  }

  void _loadMembersFromDatabase() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members');
    dbRef.onValue.listen((DatabaseEvent event) {
      final List<Member> newMembers = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          newMembers.add(Member.fromMap(value, key));
        });
      }
      setState(() {
        members = newMembers;
        isLoading = false;
      });
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

  Future<void> _deleteMember(String memberId) async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('members/$memberId');
    await dbRef.remove();
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


  void _sortMembers() {
    if (sortBy == 'name') {
      members.sort((a, b) => isAscending 
          ? a.name.compareTo(b.name) 
          : b.name.compareTo(a.name));
    } else if (sortBy == 'ward') {
      members.sort((a, b) => isAscending 
          ? a.ward.compareTo(b.ward) 
          : b.ward.compareTo(a.ward));
    }
    setState(() {});
  }

  String _formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00'); 
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = members.where((member) {
      return member.name.toLowerCase().contains(searchQuery.toLowerCase()) || 
             member.ward.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
                if (!isSearchActive) {
                  searchQuery = '';
                }
              });
            },
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (String value) {
              if (value == 'A-Z' || value == 'Z-A') {
                isAscending = (value == 'A-Z');
              } else {
                sortBy = value;
              }
              _sortMembers();
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'A-Z',
                  child: Text('Sort by A-Z'),
                ),
                const PopupMenuItem<String>(
                  value: 'Z-A',
                  child: Text('Sort by Z-A'),
                ),
              ];
            },
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator(color: Colors.blue))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (isSearchActive)
                  TextField(
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      labelText: 'Search Members',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.blue), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: Colors.transparent, 
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

                      double totalLoanTaken = member.loans.fold<double>(0, (sum, loan) => sum + loan.loanTaken);
                      double totalLoanPaid = member.loans.fold<double>(0, (sum, loan) => sum + loan.loanPaid);
                      double loanBalance = totalLoanTaken - totalLoanPaid; 
                      
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
                                    '+ K${_formatNumber(totalLoanPaid)}', 
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  // Show balance if there are payments, otherwise show total loan taken
                                  Text(
                                    totalLoanPaid > 0
                                      ? '- K${_formatNumber(loanBalance)}'
                                      : '- K${_formatNumber(totalLoanTaken)}', // Dynamically display total taken
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditMemberScreen(member: member), 
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmationDialog(member);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit Member'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete Member'),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(Icons.more_vert),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberDetailsScreen(
                                  member: member, memberId: member.id, 
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
          ),
    );
  }
}
