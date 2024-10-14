import 'package:flutter/material.dart';

class MemberData {
  final String name;
  final double value; // Use double to hold shares value
  final Color color;

  MemberData({required this.name, required this.value, required this.color});
}


// ShareDividendData class
class ShareDividendData {
  final String name;
  final int shares;
  final int dividends;

  ShareDividendData(this.name, this.shares, this.dividends);
}
