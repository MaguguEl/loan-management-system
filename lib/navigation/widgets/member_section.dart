import 'package:flutter/material.dart';
import 'dart:math';
import 'package:loan_management_system/features/member_management/member_screen.dart';

class MemberSection extends StatelessWidget {
  const MemberSection({super.key});

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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Members', style: TextStyle(fontSize: 18)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MembersScreen(
                                                memberName: 'Elvis',
                                                memberPhone: '1234567890',
                                                memberResidence: 'Mvunguti',
                                                memberWelfare: 'Good',
                                                noteDescription: 'No specific notes',
                                              ),
                      ),
                    );
                  },
                  child: const Text('View All', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, 
              itemBuilder: (context, index) {
                
                String memberName = 'Member $index';
                return Column(
                  children: [
                    MemberItem(
                      title: memberName,
                      amount: index % 2 == 0 ? '-\$150' : '+\$200',
                      date: 'Mvunguti',
                      isIncome: index % 2 == 1,
                      avatar: CircleAvatar(
                        backgroundColor: getRandomColor(),
                        child: Text(
                          memberName.isNotEmpty ? memberName[0].toUpperCase() : '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MemberItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final bool isIncome;
  final Widget avatar;

  const MemberItem({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: avatar,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(color: isIncome ? Colors.green : Colors.red),
      ),
    );
  }
}
