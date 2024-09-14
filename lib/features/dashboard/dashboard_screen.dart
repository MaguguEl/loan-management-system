import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/widget/barchart_widget.dart';

class  DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Loan and Interests
            Row(
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
            SizedBox(height: 20),
            Text('Analytics', style: TextStyle(fontSize: 18)),
            Expanded(
              child: BarChartWidget(), 
            ),
          ],
        ),
      ),
    );
  }
}
