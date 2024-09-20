import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/widget/barchart_widget.dart';

class  DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Loan and Interests
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Loans', style: TextStyle(fontSize: 16)),
                    Text('\$8,500', style: TextStyle(fontSize: 28)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Interests', style: TextStyle(fontSize: 16)),
                    Text('\$3,800', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Analytics', style: TextStyle(fontSize: 18)),
            Expanded(
              child: BarChartWidget(), 
            ),
          ],
        ),
      ),
    );
  }
}
