import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/member_management/member_detail_screen.dart';
import 'package:loan_management_system/features/member_management/member_list_screen.dart';
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

  // Initialize screens with dummy values for MembersScreen
  final List<Widget> screens = [
    const HomeScreen(),
    const DashboardScreen(),
    const ReportsScreen(),
    MemberDetailsScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF305CDE),
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
            _buildIconButton(Icons.home_filled, 'Home', 0, const HomeScreen()),
            _buildIconButton(Icons.dashboard, 'Dashboard', 1, const DashboardScreen()),
            _buildIconButton(Icons.table_view, 'Reports', 2, const ReportsScreen()),
            _buildIconButton(
              Icons.groups, 
              'Members', 
              3, 
              MemberDetailsScreen()
            ),
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
            color: currentTab == tabIndex ? Color(0xFF305CDE) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentTab == tabIndex ? Color(0xFF305CDE) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
