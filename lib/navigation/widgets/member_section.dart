import 'package:flutter/material.dart';

class MemberSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Members', style: TextStyle(fontSize: 18)),
              Text('View All', style: TextStyle(color: Colors.blue)),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,  // Example Member count
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    MemberItem(
                      title: 'Member $index',
                      amount: index % 2 == 0 ? '-\$150' : '+\$200',
                      date: 'Mvunguti',
                      isIncome: index % 2 == 1,
                    ),
                    Divider(),
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

  const MemberItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(color: isIncome ? Colors.green : Colors.red),
      ),
    );
  }
}
