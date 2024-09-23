import 'package:flutter/material.dart';
import 'dart:math';

class MembersScreen extends StatefulWidget {
  const MembersScreen({
    Key? key,
    required this.memberName,
    required this.memberPhone,
    required this.memberResidence,
    required this.memberWelfare,
    required this.noteDescription,
  }) : super(key: key);

  final String memberName;
  final String memberPhone;
  final String memberResidence;
  final String memberWelfare;
  final String noteDescription;

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Member> members = [];

  String searchQuery = '';
  String sortingCriteria = 'Name';
  String? selectedResidence;

  @override
  void initState() {
    super.initState();
    // Initialize members with widget references
    members = [
      Member(
        name: widget.memberName,
        phone: widget.memberPhone,
        residence: widget.memberResidence,
      ),
      // Add more members if needed
      // Member(name: 'Another Name', phone: '0987654321', residence: 'OtherResidence'),
    ];
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
      final matchesResidence = selectedResidence == null || member.residence == selectedResidence;

      return matchesSearch && matchesResidence;
    }).toList();

    filteredMembers.sort((a, b) {
      switch (sortingCriteria) {
        case 'Name':
          return a.name.compareTo(b.name);
        case 'Phone':
          return a.phone.compareTo(b.phone);
        case 'Residence':
          return a.residence.compareTo(b.residence);
        default:
          return 0;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
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
                  return AddedItem(
                    title: member.name,
                    date: member.phone,
                    avatar: CircleAvatar(
                      backgroundColor: getRandomColor(),
                      child: Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
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

class AddedItem extends StatelessWidget {
  final String title;
  final String date;
  final Widget avatar;

  const AddedItem({Key? key, required this.title, required this.date, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: avatar,
      title: Text(title),
      subtitle: Text(date),
      trailing: const Icon(Icons.more_vert),
    );
  }
}

class Member {
  final String name;
  final String phone;
  final String residence;

  Member({required this.name, required this.phone, required this.residence});
}
