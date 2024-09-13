import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TotalBalanceCard(),  // Total balance card at the top
            SizedBox(height: 20),
            TransactionSection(),  // Transaction section with Divider
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Balance', style: TextStyle(fontSize: 16, color: Colors.white)),
                  Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
              SizedBox(height: 10),
              Text('\$3,257.00', style: TextStyle(fontSize: 32, color: Colors.white)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Income', style: TextStyle(fontSize: 14, color: Colors.white)),
                      Text('\$2,350.00', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Expenses', style: TextStyle(fontSize: 14, color: Colors.white)),
                      Text('\$950.00', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transactions', style: TextStyle(fontSize: 18)),
              Text('See All', style: TextStyle(color: Colors.blue)),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,  // Example transaction count
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TransactionItem(
                      title: 'Transaction $index',
                      amount: index % 2 == 0 ? '-\$150' : '+\$200',
                      date: 'Today',
                      isIncome: index % 2 == 1,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),  // Divider added between each transaction
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

class TransactionItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final bool isIncome;

  const TransactionItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_balance_wallet),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(color: isIncome ? Colors.green : Colors.red),
      ),
    );
  }
}
