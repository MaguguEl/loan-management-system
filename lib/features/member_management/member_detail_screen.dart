import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';
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
  double totalInterest = 0.0;

  late DatabaseReference _loansRef;
  late Stream<DatabaseEvent> _loansStream;

  @override
  void initState() {
    super.initState();
    _loansRef = FirebaseDatabase.instance.ref().child('members').child(widget.memberId).child('loans');
    _loansStream = _loansRef.onValue; // Listen for loan updates
    _listenForLoanUpdates();
  }

  void _listenForLoanUpdates() {
    _loansStream.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final loans = event.snapshot.value as Map<dynamic, dynamic>;

        double paid = 0.0;
        double taken = 0.0;
        double interest = 0.0;

        loans.forEach((key, value) {
          paid += (value['loanPaid'] ?? 0.0) as double;
          taken += (value['loanTaken'] ?? 0.0) as double;
          interest += Loan.calculateInterest(value['loanTaken'] ?? 0.0); // Use public method to calculate interest
        });

        setState(() {
          totalPaid = paid;
          totalTaken = taken;
          totalInterest = interest;
          loanBalance = totalTaken - totalPaid + totalInterest; // Calculate the loan balance
        });
      } else {
        setState(() {
          loanBalance = 0.0;
          totalPaid = 0.0;
          totalTaken = 0.0;
          totalInterest = 0.0;
        });
      }
    }, onError: (error) {
      // Handle error appropriately, if needed
    });
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
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
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
                const Text('Loan Paid'),
                Text('+ K${totalPaid.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Interest'),
                Text('K${totalInterest.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Loan Taken'),
                Text('- K${totalTaken.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red)),
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
                      builder: (context) => AddTransactionScreen(memberId: widget.memberId),
                    ),
                  );
                },
                child: const Text(
                  'ADD LOAN',
                  style: TextStyle(color: Color(0xFF305CDE)),
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
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                amount,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
