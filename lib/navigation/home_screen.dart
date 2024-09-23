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
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black, 
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
                  imagePath: 'assets/icons/shares.png', 
                  onPressed: () {
                    // Add your shares logic here
                  },
                ),
                CustomIconButton(
                  label: 'Dividends',
                  imagePath: 'assets/icons/dividends.png', 
                  onPressed: () {
                    // Add your dividends logic here
                  },
                ),
                CustomIconButton(
                  label: 'Welfare',
                  imagePath: 'assets/icons/welfare.png', 
                  onPressed: () {
                    // Add your welfare logic here
                  },
                ),
                CustomIconButton(
                  label: 'Penalty',
                  imagePath: 'assets/icons/penalty.png', 
                  onPressed: () {
                    // Add your penalty logic here
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            MemberSection(), 
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


