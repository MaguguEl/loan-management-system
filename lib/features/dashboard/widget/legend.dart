import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class LegendDisplay extends StatelessWidget {
  final List<Member> members; 

  const LegendDisplay({Key? key, required this.members}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: members.map((member) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 16,
              color: member.color, // Assuming Member has a color property
            ),
            const SizedBox(width: 8),
            Text(member.name, style: const TextStyle(fontSize: 14)), 
          ],
        );
      }).toList(),
    );
  }
}
