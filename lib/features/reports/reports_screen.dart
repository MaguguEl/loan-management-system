import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<DataRow> _memberRows = [];
  List<Member> _members = [];
  int _totalMembers = 0;

  double _totalShares = 0;
  double _totalDividends = 0;
  double _totalSharesPlusDividend = 0;
  double _totalLoanTaken = 0;
  double _totalInterestOnLoan = 0;
  double _totalLoanPlusInterest = 0;
  double _totalLoanPaid = 0;
  double _totalNetPay = 0;
  double _totalWelfare = 0;
  double _totalPenalty = 0;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMembersData();
    _searchController.addListener(_filterMembers);
  }

  void _fetchMembersData() async {
    DatabaseReference membersRef = FirebaseDatabase.instance.ref().child('members');
    DataSnapshot snapshot = await membersRef.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> membersMap = snapshot.value as Map<dynamic, dynamic>;
      List<Member> members = membersMap.entries.map((entry) {
        String memberId = entry.key;
        Map<dynamic, dynamic> memberData = entry.value as Map<dynamic, dynamic>;
        return Member.fromMap(memberData, memberId);
      }).toList();

      _members = members;
      _resetTotals();

      setState(() {
        _totalMembers = members.length;
        _memberRows = _createStyledRows(members);
        _calculateColumnTotals(members);
      });
    }
  }

  void _filterMembers() {
    String query = _searchController.text.toLowerCase().trim();

    List<Member> filteredMembers = _members.where((member) {
      return member.name.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _memberRows = _createStyledRows(filteredMembers);
      _totalMembers = filteredMembers.length;
      _resetTotals();
      _calculateColumnTotals(filteredMembers);
    });
  }

  void _resetTotals() {
    _totalShares = 0;
    _totalDividends = 0;
    _totalSharesPlusDividend = 0;
    _totalLoanTaken = 0;
    _totalInterestOnLoan = 0;
    _totalLoanPlusInterest = 0;
    _totalLoanPaid = 0;
    _totalNetPay = 0;
    _totalWelfare = 0;
    _totalPenalty = 0;
  }

  void _calculateColumnTotals(List<Member> members) {
    for (var member in members) {
      _totalShares += member.totalShares;
      _totalDividends += member.totalDividends;
      _totalSharesPlusDividend += member.totalShares + member.totalDividends;
      _totalLoanTaken += member.totalTaken;
      _totalInterestOnLoan += member.totalInterest;
      _totalLoanPlusInterest += member.totalTaken + member.totalInterest;
      _totalLoanPaid += member.totalPaid;
      _totalNetPay += (member.totalShares + member.totalDividends) - (member.totalTaken + member.totalInterest);
      _totalWelfare += member.totalWelfares;
      _totalPenalty += member.totalPenalties;
    }
  }

  String formatNumberWithCommas(double number) {
    return number.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // Add functionality for exporting PDF here
            },
          ),
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () {
              // Add functionality for exporting Excel here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Search Members',
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.blue), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  filled: true,
                  fillColor: Colors.transparent, 
                ),
              ),
            ),
            SizedBox(height: 10),
            TableHeader(),
            SizedBox(height: 10),
            
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    horizontalMargin: 16.0,
                    headingRowHeight: 40.0,
                    dataRowHeight: 60.0,
                    columns: const [
                      DataColumn(label: Text('SR/NO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Shares', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Dividend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Shares + Dividend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Loan Taken', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Interest on Loan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Loan + Interest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Loan Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Net Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Welfare', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Penalty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      ..._memberRows,
                      DataRow(
                        cells: [
                          const DataCell(Text('Total:', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('$_totalMembers members', style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalShares), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalDividends), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalSharesPlusDividend), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalLoanTaken), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalInterestOnLoan), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalLoanPlusInterest), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalLoanPaid), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalNetPay), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalWelfare), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(formatNumberWithCommas(_totalPenalty), style: const TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _createStyledRows(List<Member> members) {
    return members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;

      final double sharesPlusDividend = member.totalShares + member.totalDividends;
      final double loanPlusInterest = member.totalTaken + member.totalInterest;
      final double netPay = sharesPlusDividend - loanPlusInterest;

      return DataRow(
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(member.name)),
          DataCell(Text(formatNumberWithCommas(member.totalShares))),
          DataCell(Text(formatNumberWithCommas(member.totalDividends))),
          DataCell(Text(formatNumberWithCommas(sharesPlusDividend))),
          DataCell(Text(formatNumberWithCommas(member.totalTaken))),
          DataCell(Text(formatNumberWithCommas(member.totalInterest))),
          DataCell(Text(formatNumberWithCommas(loanPlusInterest))),
          DataCell(Text(formatNumberWithCommas(member.totalPaid))),
          DataCell(Text(formatNumberWithCommas(netPay))),
          DataCell(Text(formatNumberWithCommas(member.totalWelfares))),
          DataCell(Text(formatNumberWithCommas(member.totalPenalties))),
        ],
      );
    }).toList();
  }
}

class TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TGC Financials',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_alt),
                onPressed: () {
                  // Add sorting logic
                },
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  // Add filtering logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
