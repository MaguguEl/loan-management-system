import 'package:flutter/material.dart';

class TotalNetPayCard extends StatelessWidget {
  const TotalNetPayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 73, 164, 238), Color.fromARGB(255, 23, 133, 230)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Total Net Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      Text('\$3,257.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      // Text('Total Net Pay', style: TextStyle(fontSize: 16, color: Colors.white)),
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                    ],
                  )
                ],
              ),             
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Total Loans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                      Text('\$2,350.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                      Text('\$950.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
