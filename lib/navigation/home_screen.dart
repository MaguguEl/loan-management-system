import 'package:flutter/material.dart';
import 'package:loan_management_system/navigation/widgets/icon_buttons.dart';
import 'package:loan_management_system/navigation/widgets/member_section.dart';
import 'package:loan_management_system/navigation/widgets/net_pay_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TotalNetPayCard(), 
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomIconButton(
                  label: 'Shares',
                  icon: Icons.pie_chart,
                  onPressed: () {
                    // Add your shares logic here
                  },
                ),
                CustomIconButton(
                  label: 'Dividends',
                  icon: Icons.attach_money,
                  onPressed: () {
                    // Add your dividends logic here
                  },
                ),
                CustomIconButton(
                  label: 'Welfare',
                  icon: Icons.local_hospital,
                  onPressed: () {
                    // Add your welfare logic here
                  },
                ),
                CustomIconButton(
                  label: 'Penalty',
                  icon: Icons.warning,
                  onPressed: () {
                    // Add your penalty logic here
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            MemberSection(), 
          ],
        ),
      ),
    );
  }
}


