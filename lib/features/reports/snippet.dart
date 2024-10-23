import 'package:flutter/material.dart';
import 'package:loan_management_system/features/member_management/model/member_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<DataRow> _memberRows = [];
  List<Member> _members = [];
  List<String> _selectedColumns = [];
  List<String> _allColumns = [
    'SR/NO',
    'Name',
    'Shares',
    'Dividend',
    'Shares + Dividend',
    'Loan Taken',
    'Interest on Loan',
    'Loan + Interest',
    'Loan Paid',
    'Net Pay',
    'Welfare',
    'Penalty'
  ];
  String? _sortColumn;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _selectedColumns = List.from(_allColumns);
    _fetchMembersData();
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

      setState(() {
        _members = members;
        _memberRows = _createStyledRows(members);
      });
    }
  }

  List<DataRow> _createStyledRows(List<Member> members) {
    return members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;

      return DataRow(
        cells: _buildRowCells(member, index + 1),
      );
    }).toList();
  }

  List<DataCell> _buildRowCells(Member member, int index) {
    List<DataCell> cells = [];

    if (_selectedColumns.contains('SR/NO')) {
      cells.add(DataCell(Text(index.toString())));
    }
    if (_selectedColumns.contains('Name')) {
      cells.add(DataCell(Text(member.name)));
    }
    if (_selectedColumns.contains('Shares')) {
      cells.add(DataCell(Text(member.totalShares.toString())));
    }
    if (_selectedColumns.contains('Dividend')) {
      cells.add(DataCell(Text(member.totalDividends.toString())));
    }
    if (_selectedColumns.contains('Shares + Dividend')) {
      cells.add(DataCell(Text((member.totalShares + member.totalDividends).toString())));
    }
    if (_selectedColumns.contains('Loan Taken')) {
      cells.add(DataCell(Text(member.totalTaken.toString())));
    }
    if (_selectedColumns.contains('Interest on Loan')) {
      cells.add(DataCell(Text(member.totalInterest.toString())));
    }
    if (_selectedColumns.contains('Loan + Interest')) {
      cells.add(DataCell(Text((member.totalTaken + member.totalInterest).toString())));
    }
    if (_selectedColumns.contains('Loan Paid')) {
      cells.add(DataCell(Text(member.totalPaid.toString())));
    }
    if (_selectedColumns.contains('Net Pay')) {
      double netPay = (member.totalShares + member.totalDividends) - (member.totalTaken + member.totalInterest);
      cells.add(DataCell(Text(netPay.toString())));
    }
    if (_selectedColumns.contains('Welfare')) {
      cells.add(DataCell(Text(member.totalWelfares.toString())));
    }
    if (_selectedColumns.contains('Penalty')) {
      cells.add(DataCell(Text(member.totalPenalties.toString())));
    }

    return cells;
  }

  void _sortData(String column) {
    setState(() {
      _sortColumn = column;
      _sortAscending = !_sortAscending;

      if (_sortAscending) {
        _members.sort((a, b) => _getMemberValue(a, column).compareTo(_getMemberValue(b, column)));
      } else {
        _members.sort((a, b) => _getMemberValue(b, column).compareTo(_getMemberValue(a, column)));
      }

      _memberRows = _createStyledRows(_members);
    });
  }

  dynamic _getMemberValue(Member member, String column) {
    switch (column) {
      case 'Name':
        return member.name;
      case 'Shares':
        return member.totalShares;
      case 'Dividend':
        return member.totalDividends;
      case 'Shares + Dividend':
        return member.totalShares + member.totalDividends;
      case 'Loan Taken':
        return member.totalTaken;
      case 'Interest on Loan':
        return member.totalInterest;
      case 'Loan + Interest':
        return member.totalTaken + member.totalInterest;
      case 'Loan Paid':
        return member.totalPaid;
      case 'Net Pay':
        return (member.totalShares + member.totalDividends) - (member.totalTaken + member.totalInterest);
      case 'Welfare':
        return member.totalWelfares;
      case 'Penalty':
        return member.totalPenalties;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Column(
        children: [
          TableHeader(
            onSort: _sortData,
            onColumnSelect: (selectedColumns) {
              setState(() {
                _selectedColumns = selectedColumns;
                _memberRows = _createStyledRows(_members);
              });
            },
            sortColumn: _sortColumn,
            sortAscending: _sortAscending,
            allColumns: _allColumns,
            selectedColumns: _selectedColumns,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: _selectedColumns.map((column) {
                      return DataColumn(
                        label: Text(column, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        onSort: (column == _sortColumn) ? (i, b) => _sortAscending ? -1 : 1 : (i, b) => _sortData(column),
                      );
                    }).toList(),
                    rows: _memberRows,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableHeader extends StatefulWidget {
  final Function(String) onSort;
  final Function(List<String>) onColumnSelect;
  final String? sortColumn;
  final bool sortAscending;
  final List<String> allColumns;
  final List<String> selectedColumns;

  const TableHeader({
    Key? key,
    required this.onSort,
    required this.onColumnSelect,
    required this.sortColumn,
    required this.sortAscending,
    required this.allColumns,
    required this.selectedColumns,
  }) : super(key: key);

  @override
  _TableHeaderState createState() => _TableHeaderState();
}

class _TableHeaderState extends State<TableHeader> {
  late List<String> tempSelectedColumns;

  @override
  void initState() {
    super.initState();
    // Initialize tempSelectedColumns with selectedColumns
    tempSelectedColumns = List.from(widget.selectedColumns);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TITHANDIDZANE CLUB',
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
                  _showColumnSelectionDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  // Trigger sorting of the selected column
                  if (tempSelectedColumns.isNotEmpty) {
                    widget.onSort(tempSelectedColumns.first);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showColumnSelectionDialog(BuildContext context) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Columns to Display'),
          content: SingleChildScrollView(
            child: Column(
              children: widget.allColumns.map((column) {
                return CheckboxListTile(
                  title: Text(column),
                  value: tempSelectedColumns.contains(column),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        tempSelectedColumns.add(column);
                      } else {
                        tempSelectedColumns.remove(column);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(tempSelectedColumns);
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget.onColumnSelect(result);
    }
  }
}
