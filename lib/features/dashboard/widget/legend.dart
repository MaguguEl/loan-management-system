import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class LegendDisplay extends StatelessWidget {
  final List<Member> members; 

  const LegendDisplay({Key? key, required this.members}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16, 
      runSpacing: 8, 
      children: members.map((member) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 24, 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                color: member.color,
              ),
              const SizedBox(width: 8),
              Text(
                member.name,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}