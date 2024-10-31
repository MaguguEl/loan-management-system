import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/reports/reports_screen.dart';
import 'package:loan_management_system/navigation/admin_profile_screen.dart';
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
    ReportScreen(),
    AdminProfileScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();

  @override
  void initState() {
    super.initState();
    currentScreen = screens[currentTab];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF305CDE),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostsScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(Icons.home_filled, 'Home', 0),
            _buildIconButton(Icons.dashboard, 'Dashboard', 1),
            _buildIconButton(Icons.table_view, 'Reports', 2),
            _buildIconButton(Icons.person, 'Admin', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, int tabIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = tabIndex;
          currentScreen = screens[tabIndex];
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: currentTab == tabIndex ? const Color(0xFF305CDE) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentTab == tabIndex ? const Color(0xFF305CDE) : Colors.grey,
              fontSize: 13
            ),
          ),
        ],
      ),
    );
  }
}
