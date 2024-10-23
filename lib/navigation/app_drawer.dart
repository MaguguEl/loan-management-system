import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/reports/reports_screen.dart';
import 'package:loan_management_system/features/settings/settings_screen.dart';
import 'package:loan_management_system/features/transactions/transactions_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
       borderRadius: BorderRadius.zero,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Tithandizane Club'),
              accountEmail: Text('999222489'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.account_circle, size: 50, color: Colors.blue),
              ),
              otherAccountsPictures: [
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Member Management'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MembersScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Transactions'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MembersScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('Reports'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ReportScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
