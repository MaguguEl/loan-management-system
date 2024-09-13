import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
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
                AddIncomeExpenseButton(text: 'Add Expense', icon: Icons.shopping_cart),
              ],
            ),
            SizedBox(height: 20),
            // Last Added Section
            Text('Last Added', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView(
                children: [
                  AddedItem(title: 'Salary', amount: '+\$1500', date: '30 Apr 2022', isIncome: true),
                  AddedItem(title: 'Paypal', amount: '+\$3500', date: '28 Apr 2022', isIncome: true),
                  AddedItem(title: 'Food', amount: '-\$300', date: '25 Apr 2022', isIncome: false),
                  // Add more items as needed
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding
        },
        child: Icon(Icons.add),
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
  final String amount;
  final String date;
  final bool isIncome;

  AddedItem({required this.title, required this.amount, required this.date, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.attach_money),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(color: isIncome ? Colors.green : Colors.red),
      ),
    );
  }
}
