import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/data/member_data.dart';
import 'package:loan_management_system/features/dashboard/widget/barchart_widget.dart';
import 'package:loan_management_system/features/dashboard/widget/legend.dart';
import 'package:loan_management_system/features/dashboard/widget/piechart_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Member> members = [];
  double totalPaid = 0.0;
  double totalTaken = 0.0;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchMemberData();
  }

  void fetchMemberData() {
    _databaseReference.child('members').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Member> tempMembers = [];
        double tempTotalPaid = 0.0;
        double tempTotalTaken = 0.0;

        data.forEach((key, value) {
          Member member = Member.fromMap(value, key);

          // Add member only if they have shares
          if (member.totalShares > 0) {
            tempMembers.add(member);
          }

          // Accumulate totalPaid and totalTaken for all members
          tempTotalPaid += member.totalPaid;
          tempTotalTaken += member.totalTaken;
        });

        setState(() {
          members = tempMembers;
          totalPaid = tempTotalPaid;
          totalTaken = tempTotalTaken;
        });
      } else {
        print('No data found.');
      }
    });
  }

  double calculatePercentage(double value, double total) {
    return total == 0 ? 0.0 : (value / total) * 100;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = totalPaid + totalTaken;
    double paidPercentage = calculatePercentage(totalPaid, totalAmount);
    double takenPercentage = calculatePercentage(totalTaken, totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFinancialCard(
                  'Total Paid',
                  '${paidPercentage.toStringAsFixed(2)}%',
                  Icons.arrow_drop_up,
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildFinancialCard(
                  'Total Taken',
                  '${takenPercentage.toStringAsFixed(2)}%',
                  Icons.arrow_drop_down,
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ChartsPage(members: members), 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(String title, String amount, IconData icon, Color iconColor) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  Text(amount, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartsPage extends StatelessWidget {
  final List<Member> members;

  const ChartsPage({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(child: Text('No member data available.'));
    }
    List<MemberData> memberData = members.map((member) {
      return MemberData(
        name: member.name,
        value: member.totalShares,
        color: member.color,
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Pie Charts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Container(
            height: 300,
            child: PieChartWidget(members: members), 
          ),
          const SizedBox(height: 10),
          LegendDisplay(members: members),
          const SizedBox(height: 50),
          const Text('Bar Charts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Container(
            height: 400,
            child: BarChartWidget(members: members),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
