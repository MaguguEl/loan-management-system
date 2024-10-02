import 'package:flutter/material.dart';

class MemberDetailsScreen extends StatefulWidget {
  const MemberDetailsScreen({
    Key? key,
    required this.memberName,
    required this.memberPhone,
    required this.memberEmail,
    required this.memberWard,
    required this.memberShares,
    required this.noteDescription,
  }) : super(key: key);

  final String memberName;
  final String memberPhone;
  final String memberEmail;
  final String memberWard;
  final String memberShares;
  final String noteDescription;

  @override
  _MemberDetailsScreenState createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Member Details'),
              pinned: true,
              backgroundColor: Colors.white,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member Information Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade700,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.memberName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text( widget.memberWard,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(widget.memberPhone),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(widget.memberEmail),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Account',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildAccountDetailCard('Shares', widget.memberShares, Colors.blue.shade100, Colors.blue),
                    _buildAccountDetailCard('Dividend', 'K200,000', Colors.purple.shade100, Colors.purple),
                    _buildAccountDetailCard('Loan Taken', 'K200,000', Colors.red.shade100, Colors.red),
                    _buildAccountDetailCard('Loan Paid', 'K200,000', Colors.green.shade100, Colors.green),
                    _buildAccountDetailCard('Welfare', 'K200,000', Colors.orange.shade100, Colors.orange),
                    _buildAccountDetailCard('Penalty', 'K200,000', Colors.yellow.shade100, Colors.yellow),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDetailCard(String title, String amount, Color backgroundColor, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: 2), // Border color
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: borderColor, size: 30), // Icon representing the card
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        amount,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        color: backgroundColor, // Light background color for each card
      ),
    );
  }
}

