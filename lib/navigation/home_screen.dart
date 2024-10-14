import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';
import 'package:loan_management_system/features/transactions/dividends.dart';
import 'package:loan_management_system/features/transactions/penalty.dart';
import 'package:loan_management_system/features/transactions/shares.dart';
import 'package:loan_management_system/features/transactions/welfare.dart';
import 'package:loan_management_system/navigation/widgets/icon_buttons.dart';
import 'package:loan_management_system/navigation/widgets/member_section.dart';
import 'package:loan_management_system/navigation/widgets/net_pay_card.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _totalNetPay = 0;
  double _totalLoansTaken = 0;
  double _totalLoansPaid = 0;
  List<Member> _members = []; 

  @override
  void initState() {
    super.initState();
    _fetchMembersData(); 
  }

  void _fetchMembersData() async {
    DatabaseReference membersRef = FirebaseDatabase.instance.ref().child('members');
    DataSnapshot snapshot = await membersRef.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> membersMap = snapshot.value as Map<dynamic, dynamic>;

      _members = membersMap.entries.map((entry) {
        String memberId = entry.key;
        Map<dynamic, dynamic> memberData = entry.value as Map<dynamic, dynamic>;
        return Member.fromMap(memberData, memberId);
      }).toList();

      _calculateTotals(); // Calculate totals after fetching members

      setState(() {}); 
    }
  }

  void _calculateTotals() {
    // Reset totals before calculating
    _totalNetPay = 0;
    _totalLoansTaken = 0;
    _totalLoansPaid = 0;

    for (var member in _members) {
      _totalLoansTaken += member.totalTaken;
      _totalLoansPaid += member.totalPaid;
      _totalNetPay += (member.totalShares + member.totalDividends) - 
                      (member.totalTaken + member.totalInterest);
    }
  }
  
    // GlobalKey to control the Scaffold for opening the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Opening the drawer using the GlobalKey
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TotalNetPayCard(
                totalNetPay: _totalNetPay,
                totalLoansTaken: _totalLoansTaken,
                totalLoansPaid: _totalLoansPaid,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomIconButton(
                    label: 'Shares',
                    imagePath: 'assets/icons/shares.png',
                    onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SharesScreen(),
                      ),
                    );
                    },
                  ),
                  CustomIconButton(
                    label: 'Dividends',
                    imagePath: 'assets/icons/dividends.png',
                    onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DividendsScreen(),
                      ),
                    );
                    },
                  ),
                  CustomIconButton(
                    label: 'Welfare',
                    imagePath: 'assets/icons/welfare.png',
                    onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelfareScreen(),
                      ),
                    );
                    },
                  ),
                  CustomIconButton(
                    label: 'Penalty',
                    imagePath: 'assets/icons/penalty.png',
                    onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PenaltyScreen(),
                      ),
                    );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 300, 
                child: const MemberSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



