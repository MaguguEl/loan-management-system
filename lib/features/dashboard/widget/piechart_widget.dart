import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class PieChartWidget extends StatelessWidget {
  final List<Member> members;

  const PieChartWidget({super.key, required this.members});

  @override
  Widget build(BuildContext context) {

    final totalShares = members.fold(0.0, (sum, member) => sum + member.totalShares);

    return PieChart(
      PieChartData(
        sections: members.map((member) {
          final percentage = totalShares > 0 ? (member.totalShares / totalShares * 100).toStringAsFixed(1) : '0.0';
          return PieChartSectionData(
            value: member.totalShares,
            title: '$percentage%',
            color: member.color,
            radius: 100,
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
    );
  }
}
