import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loan_management_system/features/dashboard/data/member_data.dart';

class PieChartWidget extends StatelessWidget {
  final List<MemberData> memberData; 

  const PieChartWidget({super.key, required this.memberData}); 

  @override
  Widget build(BuildContext context) {
    // Calculate total shares as double
    final totalShares = memberData.fold(0.0, (sum, item) => sum + item.value); 

    return PieChart(
      PieChartData(
        sections: memberData.map((datum) {
          final percentage = totalShares > 0 ? (datum.value / totalShares * 100).toStringAsFixed(1) : '0.0'; 
          return PieChartSectionData(
            value: datum.value.toDouble(),
            title: '$percentage%',  
            color: datum.color,
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
