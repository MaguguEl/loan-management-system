import 'package:flutter/material.dart';

class AddMemberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddIncomeExpenseButton(text: 'Add Income', icon: Icons.account_balance_wallet),
                AddIncomeExpenseButton(text: 'Add Expense', icon: Icons.wallet_giftcard_outlined),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  AddedItem(title: 'Magugu', date: '30 Apr 2022'),
                  Divider(),
                  AddedItem(title: 'Manyera', date: '28 Apr 2022'),
                  Divider(),
                  AddedItem(title: 'Menyamenya', date: '25 Apr 2022'),
                  Divider(),
                  AddedItem(title: 'Magombo', date: '28 Apr 2022'),
                  
                  // Add more items as needed
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Action for adding
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddIncomeExpenseButton extends StatelessWidget {
  final String text;
  final IconData icon;

  AddIncomeExpenseButton({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add your action
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}

class AddedItem extends StatelessWidget {
  final String title;
  final String date;

  AddedItem({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(title),
      subtitle: Text(date),
      trailing: Icon(Icons.more_vert)
    );
  }
}
