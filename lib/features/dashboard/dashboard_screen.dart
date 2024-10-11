import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/widget/barchart_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
            // Total Loan and Interests wrapped in Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Paid', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8), // Add space between the texts
                        const Text('\$8,500', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Taken', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8), // Add space between the texts
                        const Text('\$3,800', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                  ),
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
