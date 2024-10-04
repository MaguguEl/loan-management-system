import 'dart:ui';
import 'package:flutter/material.dart';

class Loan {
  String id;
  double loanAmount;
  double loanPaid;
  double loanTaken;

  Loan({
    required this.id,
    required this.loanAmount,
    required this.loanPaid,
    required this.loanTaken,
  });

  // Factory method to create a Loan instance from Firebase data
  factory Loan.fromMap(Map<dynamic, dynamic> map, String id) {
    return Loan(
      id: id,
      loanAmount: map['loanAmount'] ?? 0.0,
      loanPaid: map['loanPaid'] ?? 0.0,
      loanTaken: map['loanTaken'] ?? 0.0,
    );
  }

  // Converts a Loan object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'loanAmount': loanAmount,
      'loanPaid': loanPaid,
      'loanTaken': loanTaken,
    };
  }
}

class Member {
  String id;
  String name;
  String phone;
  String? email;
  String ward;
  String shares;
  String? noteDescription;
  Color color;
  List<Loan> loans;  // List to store loans
  double totalPaid;   // Total amount paid
  double totalTaken;  // Total amount taken
  double loanBalance; // Current loan balance

  Member({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    required this.shares,
    this.noteDescription,
    required this.color,
    this.loans = const [],  // Initialize the loans list
    this.totalPaid = 0.0,   // Initialize totalPaid
    this.totalTaken = 0.0,  // Initialize totalTaken
    this.loanBalance = 0.0,  // Initialize loanBalance
  });

  factory Member.fromMap(Map<dynamic, dynamic> map, String id) {
    List<Loan> loans = [];

    // Populate the loans list if available
    if (map['loans'] != null) {
      for (var loanId in map['loans'].keys) {
        loans.add(Loan.fromMap(map['loans'][loanId], loanId));
      }
    }

    // Calculate totalPaid and totalTaken
    double totalPaid = loans.fold(0.0, (sum, loan) => sum + loan.loanPaid);
    double totalTaken = loans.fold(0.0, (sum, loan) => sum + loan.loanTaken);

    return Member(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      ward: map['ward'] ?? '',
      shares: map['shares'] ?? '',
      noteDescription: map['noteDescription'],
      color: Color(map['color'] ?? Colors.blue.value),
      loans: loans,  // Assign the loans list
      totalPaid: totalPaid,  // Assign totalPaid
      totalTaken: totalTaken, // Assign totalTaken
      loanBalance: totalTaken - totalPaid, // Calculate loan balance
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'ward': ward,
      'shares': shares,
      'noteDescription': noteDescription,
      'color': color.value,
      'loans': {for (var loan in loans) loan.id: loan.toMap()},  // Save loans to Firebase
      'totalPaid': totalPaid,
      'totalTaken': totalTaken,
      'loanBalance': loanBalance,
    };
  }
}
