import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class BarChartWidget extends StatefulWidget {
  final List<Member> members; // List of members with loan data

  const BarChartWidget({Key? key, required this.members}) : super(key: key);

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Shares & Dividends'),
              Tab(text: 'Loans'),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSharesAndDividendsChart(),
                _buildLoanChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharesAndDividendsChart() {
    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxSharesAndDividendsY(),
              barGroups: widget.members.asMap().entries.map((entry) {
                int index = entry.key;
                Member member = entry.value;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: member.totalShares,
                      color: Colors.blue,
                      width: 20,
                    ),
                    BarChartRodData(
                      toY: member.totalDividends,
                      color: Colors.orange,
                      width: 20,
                    ),
                  ],
                );
              }).toList(),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 80,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < widget.members.length) {
                        final surname = widget.members[index].name.split(' ').last;

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10.0,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(0.5),
                              child: Text(
                                surname,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildLegend(['Shares', 'Dividends'], [Colors.blue, Colors.orange]),
      ],
    );
  }

  Widget _buildLoanChart() {
    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxLoanY(),
              barGroups: widget.members.asMap().entries.map((entry) {
                int index = entry.key;
                Member member = entry.value;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: member.totalPaid,
                      color: Colors.green,
                      width: 20,
                    ),
                    BarChartRodData(
                      toY: member.totalTaken,
                      color: Colors.red,
                      width: 20,
                    ),
                  ],
                );
              }).toList(),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 80,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < widget.members.length) {
                        final surname = widget.members[index].name.split(' ').last;

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10.0,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationZ(0.5),
                              child: Text(
                                surname,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildLegend(['Loan Paid', 'Loan Taken'], [Colors.green, Colors.red]),
      ],
    );
  }

  Widget _buildLegend(List<String> labels, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: colors[index],
              ),
              const SizedBox(width: 4),
              Text(labels[index]),
            ],
          ),
        );
      }),
    );
  }

  double _getMaxSharesAndDividendsY() {
    double maxShares = widget.members.map((m) => m.totalShares).reduce((a, b) => a > b ? a : b);
    double maxDividends = widget.members.map((m) => m.totalDividends).reduce((a, b) => a > b ? a : b);
    return (maxShares > maxDividends ? maxShares : maxDividends) * 1.2;
  }

  double _getMaxLoanY() {
    double maxPaid = widget.members.map((m) => m.totalPaid).reduce((a, b) => a > b ? a : b);
    double maxTaken = widget.members.map((m) => m.totalTaken).reduce((a, b) => a > b ? a : b);
    return (maxPaid > maxTaken ? maxPaid : maxTaken) * 1.2;
  }
}
