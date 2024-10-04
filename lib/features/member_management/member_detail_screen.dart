import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/transactions/add_transaction_screen.dart';

class MemberDetailsScreen extends StatefulWidget {
  final String memberId;
  final String memberName; 
  final String memberPhone; 
  final String memberEmail; 
  final String memberWard; 
  final String memberShares; 
  final String noteDescription; 

  const MemberDetailsScreen({
    Key? key,
    required this.memberId,
    required this.memberName,
    required this.memberPhone,
    required this.memberEmail,
    required this.memberWard,
    required this.memberShares,
    required this.noteDescription,
  }) : super(key: key);

  @override
  _MemberDetailsScreenState createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  double loanBalance = 0.0;
  double totalPaid = 0.0;
  double totalTaken = 0.0;

  final DatabaseReference _loansRef = FirebaseDatabase.instance.ref().child('members');

  @override
  void initState() {
    super.initState();
    _fetchLoanData();
  }

  Future<void> _fetchLoanData() async {
    final snapshot = await _loansRef.child(widget.memberId).child('loans').once();

    if (snapshot.snapshot.value != null) {
      final loans = snapshot.snapshot.value as Map<dynamic, dynamic>;

      double paid = 0.0;
      double taken = 0.0;

      loans.forEach((key, value) {
        // Check if 'loanPaid' and 'loanTaken' exist in the loan data
        paid += (value['loanPaid'] ?? 0.0) as double;
        taken += (value['loanTaken'] ?? 0.0) as double;
      });

      setState(() {
        totalPaid = paid;
        totalTaken = taken;
        loanBalance = totalTaken - totalPaid; // Calculate loan balance
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text('Member Details'),
              pinned: true,
              backgroundColor: Colors.white,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member Information Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade700,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.memberName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.memberWard,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(widget.memberPhone),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(widget.memberEmail),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_horiz),
                ],
              ),

              const SizedBox(height: 16),
              _buildLoanBalanceCard(),
              const SizedBox(height: 16),
              const Text(
                'Account',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAccountDetailCard('Shares', widget.memberShares, Colors.blue.shade100, Colors.blue),
                    _buildAccountDetailCard('Dividend', 'K200,000', Colors.purple.shade100, Colors.purple),
                    _buildAccountDetailCard('Welfare', 'K200,000', Colors.orange.shade100, Colors.orange),
                    _buildAccountDetailCard('Penalty', 'K200,000', Colors.yellow.shade100, Colors.yellow),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanBalanceCard() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loan Balance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'K${loanBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Loan Paid (+)'),
                Text('K${totalPaid.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Loan Taken (-)'),
                Text('K${totalTaken.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransactionScreen(memberId: widget.memberId), // Remove 'const' here
                    ),
                  );
                },
                child: const Text(
                  'ADD LOAN',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetailCard(String title, String amount, Color backgroundColor, Color borderColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 2), // Border color
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: borderColor, size: 30), // Icon representing the card
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey), // Trailing arrow icon
          ],
        ),
      ),
      color: backgroundColor, // Light background color for each card
    ),
  );
}
}
