import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Income and Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Income', style: TextStyle(fontSize: 16)),
                    Text('\$8,500', style: TextStyle(fontSize: 28)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Expenses', style: TextStyle(fontSize: 16)),
                    Text('\$3,800', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Statistics Graph
            Text('Statistics', style: TextStyle(fontSize: 18)),
            Expanded(
              child: BarChartWidget(), // Implement a custom widget or use a Flutter chart package
            ),
            // Income and Expense toggles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Income'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Expenses'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(child: Text('Bar Chart Placeholder')),
    );
  }
}
