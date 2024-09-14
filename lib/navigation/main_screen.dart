import 'package:flutter/material.dart';
import 'package:loan_management_system/features/dashboard/dashboard_screen.dart';
import 'package:loan_management_system/features/member_management/member_screen.dart';
import 'package:loan_management_system/features/reports/reports_screen.dart';
import 'package:loan_management_system/navigation/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentTab = 0;
  final List<Widget> screens =[
    HomeScreen(),
    DashboardScreen(),
    ReportsScreen(),
    AddMemberScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white,),
        shape: CircleBorder(),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
       child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = HomeScreen();
                      currentTab = 0;
                    });
                  },
                  icon: Icon(
                        Icons.home_filled,
                        color: currentTab == 0? Colors.blue : Colors.grey,
                  ),
                ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = DashboardScreen();
                      currentTab = 1;
                    });
                  },
                  icon: Icon(
                        Icons.dashboard,
                        color: currentTab == 1? Colors.blue : Colors.grey,
                  ),
                ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = ReportsScreen();
                      currentTab = 2;
                    });
                  },
                  icon: Icon(
                        Icons.bar_chart,
                        color: currentTab == 2? Colors.blue : Colors.grey,
                      ),
                ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = AddMemberScreen();
                      currentTab = 3;
                    });
                  },
                  icon: Icon(
                        Icons.groups,
                        color: currentTab == 3? Colors.blue : Colors.grey,
                      ),
                ),
            ],
          ),
      ),
    );
  }
}
