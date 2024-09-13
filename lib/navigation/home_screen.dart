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
            SizedBox(height: 30),
            MemberSection(),  // Member section with Divider
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            colors: [Color.fromARGB(255, 73, 164, 238), Color.fromARGB(255, 23, 133, 230)],
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
              itemCount: 3,  // Example Member count
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    MemberItem(
                      title: 'Member $index',
                      amount: index % 2 == 0 ? '-\$150' : '+\$200',
                      date: 'Mvunguti',
                      isIncome: index % 2 == 1,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
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
