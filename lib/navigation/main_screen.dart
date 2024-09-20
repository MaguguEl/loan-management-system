import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/reports/reports_screen.dart';
import 'package:loan_management_system/navigation/posts_screen.dart';
import 'package:loan_management_system/navigation/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(),
    DashboardScreen(),
    ReportsScreen(),
    MembersScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostsScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(Icons.home_filled, 'Home', 0, HomeScreen()),
            _buildIconButton(Icons.dashboard, 'Dashboard', 1, DashboardScreen()),
            _buildIconButton(Icons.table_view, 'Reports', 2, ReportsScreen()),
            _buildIconButton(Icons.groups, 'Members', 3, MembersScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, int tabIndex, Widget screen) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentScreen = screen;
          currentTab = tabIndex;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: currentTab == tabIndex ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentTab == tabIndex ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
