import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';

class ReportTableScreen extends StatefulWidget {
  const ReportTableScreen({super.key});

  @override
  _ReportTableScreenState createState() => _ReportTableScreenState();
}

class _ReportTableScreenState extends State<ReportTableScreen> {
  List<DataRow> _memberRows = [];

  @override
  void initState() {
    super.initState();
    _fetchMembersData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              DataColumn(label: Text('SR/NO', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Shares', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Dividend', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Shares + Dividend', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Loan Taken', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Interest on Loan', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Loan + Interest', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Loan Paid', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Net Pay', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Welfare', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Punishment', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _memberRows,
          ),
        ),
      ),
    );
  }

  // Fetches member data from Firebase and maps it to Member objects
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

      setState(() {
        _memberRows = _createStyledRows(members);
      });
    }
  }

  // Uses Member model data to populate DataRows
  List<DataRow> _createStyledRows(List<Member> members) {
    return members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;

      // Calculations using model data (e.g., total shares + dividends, loan + interest, etc.)
      final double sharesPlusDividend = member.totalShares + member.totalDividends;
      final double loanPlusInterest = member.totalTaken + member.totalInterest;
      final double netPay = sharesPlusDividend - loanPlusInterest;

      return DataRow(
        cells: [
          _buildColoredCell((index + 1).toString()),
          _buildColoredCell(member.name),
          _buildColoredCell(formatNumberWithCommas(member.totalShares)),
          _buildColoredCell(formatNumberWithCommas(member.totalDividends)),
          _buildColoredCell(formatNumberWithCommas(sharesPlusDividend)),
          _buildColoredCell(formatNumberWithCommas(member.totalTaken)),
          _buildColoredCell(formatNumberWithCommas(member.totalInterest)),
          _buildColoredCell(formatNumberWithCommas(loanPlusInterest)),
          _buildColoredCell(formatNumberWithCommas(member.totalPaid)),
          _buildColoredCell(
            formatNumberWithCommas(netPay),
            color: netPay < 0 ? Colors.red : Colors.green,
          ),
          _buildColoredCell(formatNumberWithCommas(member.totalWelfares)),
          _buildColoredCell(formatNumberWithCommas(member.totalPenalties)),
        ],
      );
    }).toList();
  }

  DataCell _buildColoredCell(String text, {Color color = Colors.black}) {
    return DataCell(
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}

// Utility function to format numbers with commas
String formatNumberWithCommas(double number) {
  return number.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
}
