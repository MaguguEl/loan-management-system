import 'package:flutter/material.dart';
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
  double totalShares = 0.0;
  double totalDividends = 0.0;
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
        double tempTotalShares = 0.0; 
        double tempTotalDividends = 0.0; 

        data.forEach((key, value) {
          Member member = Member.fromMap(value, key);

          if (member.totalShares > 0) {
            tempMembers.add(member);
          }

          tempTotalPaid += member.totalPaid;
          tempTotalTaken += member.totalTaken;
          tempTotalShares += member.totalShares; 
          tempTotalDividends += member.totalDividends; 
        });

        setState(() {
          members = tempMembers;
          totalPaid = tempTotalPaid;
          totalTaken = tempTotalTaken;
          totalShares = tempTotalShares; 
          totalDividends = tempTotalDividends; 
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Dashboard'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            pinned: true, 
            elevation: 0, 
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildFinancialCard(totalPaid, totalTaken, paidPercentage, takenPercentage),
                  const SizedBox(height: 20),
                  const Text('Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ChartsPage(members: members, totalShares: totalShares, totalDividends: totalDividends),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(double totalPaid, double totalTaken, double paidPercentage, double takenPercentage) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.arrow_drop_up, color: Colors.green),
                      Text('${paidPercentage.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.black, thickness: 1), 
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Taken', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.arrow_drop_down, color: Colors.red),
                      Text('${takenPercentage.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartsPage extends StatelessWidget {
  final List<Member> members;
  final double totalShares; 
  final double totalDividends; 

  const ChartsPage({
    super.key,
    required this.members,
    required this.totalShares,
    required this.totalDividends,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(child: Text('No member data available.'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          SizedBox(height: 10),
          Container(
            height: 400,
            child: PieChartWidget(members: members, isDividends: true), 
          ),
          SizedBox(height: 16), 
          LegendDisplay(members: members),
          SizedBox(height: 20), 
        ],
      ),
    );
  }
}
