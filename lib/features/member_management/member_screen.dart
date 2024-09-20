import 'package:flutter/material.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  AddedItem(title: 'Magugu', date: '30 Apr 2022'),
                  const Divider(),
                  AddedItem(title: 'Manyera', date: '28 Apr 2022'),
                  const Divider(),
                  AddedItem(title: 'Menyamenya', date: '25 Apr 2022'),
                  const Divider(),
                  AddedItem(title: 'Magombo', date: '28 Apr 2022'),
                  
                  // Add more items as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddIncomeExpenseButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const AddIncomeExpenseButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add your action
      },
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}

class AddedItem extends StatelessWidget {
  final String title;
  final String date;

  const AddedItem({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(title),
      subtitle: Text(date),
      trailing: const Icon(Icons.more_vert)
    );
  }
}
