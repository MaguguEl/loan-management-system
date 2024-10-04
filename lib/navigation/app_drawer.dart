import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/reports/reports_screen.dart';
import 'package:loan_management_system/features/settings/settings_screen.dart';
import 'package:loan_management_system/features/transactions/transactions_screen.dart';
import 'package:loan_management_system/navigation/home_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Loan Management System'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Member Management'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Transactions'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TransactionsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Reports'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReportsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Help & Support'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReportsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}