import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class PieChartWidget extends StatefulWidget {
  final List<Member> members;
  final bool isDividends;

  const PieChartWidget({super.key, required this.members, this.isDividends = false});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Shares'),
              Tab(text: 'Dividends'),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.blueGrey,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPieChart(screenWidth, true),  // For Shares
                _buildPieChart(screenWidth, false), // For Dividends
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(double screenWidth, bool isShares) {
    final total = isShares
        ? widget.members.fold(0.0, (sum, member) => sum + member.totalShares)
        : widget.members.fold(0.0, (sum, member) => sum + member.totalDividends);
    final pieChartRadius = screenWidth * 0.35;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
      child: Center(
        child: SizedBox(
          width: screenWidth * 0.95,
          height: pieChartRadius * 2.5,
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: PieChart(
                PieChartData(
                  sections: widget.members.map((member) {
                    final memberValue = isShares ? member.totalShares : member.totalDividends;
                    final percentage = total > 0
                        ? (memberValue / total * 100).toStringAsFixed(1)
                        : '0.0';
                    return PieChartSectionData(
                      value: memberValue,
                      title: '$percentage%',
                      color: member.color,
                      radius: pieChartRadius,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
