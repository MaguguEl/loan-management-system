import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.account_circle, color: Colors.grey[700]),
              ),
              title: Text("Zwingli"),
              subtitle: Row(
                children: [
                  Icon(Icons.verified, color: Colors.blue, size: 16),
                  SizedBox(width: 4),
                  Text("Admin Profile", style: TextStyle(color: Colors.blue)),
                ],
              ),
              trailing: Icon(Icons.edit, color: Colors.blue),
            ),
          ),

           // Basic Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "General Setting",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
          ),
               _buildSettingsItem(context, Icons.group, "Members Management", "Add, update or remove member", MembersScreen(), Colors.blue),
          Divider(),
          _buildSettingsItem(context, Icons.notifications, "Notification", "View Notification", NotificationScreen(), Colors.orange),
          Divider(),
          _buildSettingsItem(context, Icons.dashboard, "Overview", "View Dashboard", DashboardScreen(), Colors.green),
          Divider(),
          _buildSettingsItem(context, Icons.assessment, "Report", "Generate reports", RequestsScreen(), Colors.purple),
          Divider(),
          _buildSettingsItem(context, Icons.settings, "Account Settings", "Settings specific to admin", BusinessSettingsScreen(), Colors.teal),
          Divider(),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Miscellaneous",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
          ),
          _buildSettingsItem(context, Icons.help, "Help & Support", "Get assistance and FAQs", HelpScreen(), Colors.lightBlue), 
          Divider(),
          _buildSettingsItem(context, Icons.settings_applications, "App Settings", "Customize app behavior", AppSettingsScreen(), Colors.amber), 
          Divider(),

          SizedBox(height: 10),
          // Logout Section
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Implement logout functionality here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, String subtitle, Widget destinationScreen, Color backgroundColor) {
  return ListTile(
    leading: Container(
      padding: EdgeInsets.all(8), 
      decoration: BoxDecoration(
        color: backgroundColor, 
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(icon, color: Colors.white), // White icon
    ),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationScreen),
      );
    },
  );
}

}

// Placeholder Screens for Navigation
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification"),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(child: Text("Notification Screen")),
    );
  }
}

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Requests"),leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(child: Text("Requests Screen")),
    );
  }
}

class BusinessSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Business Settings"),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(child: Text("Business Settings Screen")),
    );
  }
}

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help & Support"),leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(child: Text("Help & Support Screen")),
    );
  }
}

class AppSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Settings"),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(child: Text("App Settings Screen")),
    );
  }
}