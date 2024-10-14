import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/data/member_data.dart';

class LegendDisplay extends StatelessWidget {
  final List<MemberData> memberData;

  const LegendDisplay({super.key, required this.memberData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: memberData.map((datum) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 16,
              color: datum.color,
            ),
            const SizedBox(width: 8),
            Text(datum.name, style: const TextStyle(fontSize: 14)), 
          ],
        );
      }).toList(),
    );
  }
}
