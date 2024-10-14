import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_management_system/features/transactions/add_account_screen.dart';
import 'package:loan_management_system/features/transactions/add_penalty_screen.dart';
import 'package:loan_management_system/features/transactions/add_shares_screen.dart';
import 'package:loan_management_system/features/transactions/add_transaction_screen.dart';
import 'package:loan_management_system/features/transactions/add_welfare_screen.dart';
import 'package:loan_management_system/features/transactions/model/loan_model.dart';

class MemberDetailsScreen extends StatefulWidget {
  final String memberId;
  final String memberName;
  final String memberPhone;
  final String memberEmail;
  final String memberWard;
  final String noteDescription;

  const MemberDetailsScreen({
    Key? key,
    required this.memberId,
    required this.memberName,
    required this.memberPhone,
    required this.memberEmail,
    required this.memberWard,
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
  double totalShare = 0.0;
  double totalDividend = 0.0;
  double totalWelfare = 0.0;
    double totalPenalty = 0.0;

  late DatabaseReference _loansRef;
  late DatabaseReference _sharesRef;
  late DatabaseReference _dividendsRef;
  late DatabaseReference _welfareRef;
  late DatabaseReference _penaltyRef;
  late Stream<DatabaseEvent> _loansStream;
  late Stream<DatabaseEvent> _sharesStream;
  late Stream<DatabaseEvent> _dividendsStream;
  late Stream<DatabaseEvent> _welfareStream;
   late Stream<DatabaseEvent> _penaltyStream;

  @override
  void initState() {
    super.initState();
    _loansRef = FirebaseDatabase.instance.ref().child('members').child(widget.memberId).child('loans');
    _loansStream = _loansRef.onValue;
    _listenForLoanUpdates();

    _sharesRef = FirebaseDatabase.instance.ref().child('members').child(widget.memberId).child('shares');
    _sharesStream = _sharesRef.onValue;
    _listenForShareUpdates();

    _dividendsRef = FirebaseDatabase.instance.ref().child('members').child(widget.memberId).child('dividends');
    _dividendsStream = _dividendsRef.onValue;
    _listenForDividendUpdates();

    _welfareRef = FirebaseDatabase.instance.ref().child('members').child(widget.memberId).child('welfare');
    _welfareStream = _welfareRef.onValue;
    _listenForWelfareUpdates();

    _penaltyRef = FirebaseDatabase.instance.ref().child('members').child(widget.memberId).child('penalties');
    _penaltyStream = _penaltyRef.onValue;
    _listenForPenaltyUpdates();
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
          interest += Loan.calculateInterest(value['loanTaken'] ?? 0.0);
        });

        setState(() {
          totalPaid = paid;
          totalTaken = taken;
          totalInterest = interest;
          loanBalance = totalTaken - totalPaid + totalInterest;
        });
      } else {
        setState(() {
          loanBalance = 0.0;
          totalPaid = 0.0;
          totalTaken = 0.0;
          totalInterest = 0.0;
        });
      }
    });
  }
    void _listenForShareUpdates() {
    _sharesStream.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final shares = event.snapshot.value as Map<dynamic, dynamic>;

        double totalShares = 0.0;

        shares.forEach((key, value) {
          totalShares += (value['amount'] ?? 0.0) as double;
        });

        setState(() {
          totalShare = totalShares;
        });
      } else {
        setState(() {
          totalShare = 0.0;
        });
      }
    });
  }

  void _listenForDividendUpdates() {
    _dividendsStream.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final dividends = event.snapshot.value as Map<dynamic, dynamic>;

        double totalDividends = 0.0;

        dividends.forEach((key, value) {
          totalDividends += (value['amount'] ?? 0.0) as double;
        });

        setState(() {
          totalDividend = totalDividends;
        });
      } else {
        setState(() {
          totalDividend = 0.0;
        });
      }
    });
  }

  void _listenForWelfareUpdates() {
    _welfareStream.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final welfareData = event.snapshot.value as Map<dynamic, dynamic>;

        double totalWelfares = 0.0;

        welfareData.forEach((key, value) {
          totalWelfares += (value['amount'] ?? 0.0) as double;
        });

        setState(() {
          totalWelfare = totalWelfares;
        });
      } else {
        setState(() {
          totalWelfare = 0.0;
        });
      }
    });
  }

    void _listenForPenaltyUpdates() {
    _penaltyStream.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final penaltyData = event.snapshot.value as Map<dynamic, dynamic>;

        double totalPenalties = 0.0;

        penaltyData.forEach((key, value) {
          totalPenalties += (value['amount'] ?? 0.0) as double;
        });

        setState(() {
          totalPenalty = totalPenalties;
        });
      } else {
        setState(() {
          totalPenalty = 0.0;
        });
      }
    });
  }

    // Function to format numbers
  String _formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00'); // Customize the format as needed
    return formatter.format(number);
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildAccountDetailTile(
                      'Shares',
                      'K${_formatNumber(totalShare)}',
                      AddSharesScreen(memberId: widget.memberId),
                    ),
                    Divider(),
                    _buildAccountDetailTile(
                      'Dividend',
                      'K${_formatNumber(totalDividend)}',
                      AddAccountScreen(memberId: widget.memberId),
                    ),
                    Divider(),
                    _buildAccountDetailTile(
                      'Welfare',
                      'K${_formatNumber(totalWelfare)}',
                      AddWelfareScreen(memberId: widget.memberId),
                    ),
                    Divider(),
                    _buildAccountDetailTile(
                      'Penalty',
                      'K${_formatNumber(totalPenalty)}',
                      AddPenaltyScreen(memberId: widget.memberId),
                    ),
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
                  'K${_formatNumber(loanBalance)}',
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
                Text('+ K${_formatNumber(totalPaid)}', style: const TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Interest'),
                Text('K${_formatNumber(totalInterest)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Loan Taken'),
                Text('- K${_formatNumber(totalTaken)}', style: const TextStyle(color: Colors.red)),
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

  Widget _buildAccountDetailTile(String title, String amount, Widget screen) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: Icon(Icons.account_balance_wallet,),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        amount,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
