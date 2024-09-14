import 'package:flutter/material.dart';
import 'package:loan_management_system/navigation/widgets/member_section.dart';
import 'package:loan_management_system/navigation/widgets/net_pay_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TotalNetPayCard(), 
            SizedBox(height: 30),
            MemberSection(), 
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}


