import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

class Loan {
  String id;
  double loanAmount;
  double loanPaid;
  double loanTaken;
  double interest; // Field to store interest

  Loan({
    required this.id,
    required this.loanAmount,
    required this.loanPaid,
    required this.loanTaken,
  }) : interest = _calculateInterest(loanAmount); // Calculate interest on instantiation

  // Public Interest Calculation based on loan amount
  static double _calculateInterest(double loanAmount) {
    if (loanAmount < 100000) {
      return 0.0;
    } else if (loanAmount >= 100000 && loanAmount < 1000000) {
      return loanAmount * 0.05; // 5% interest
    } else if (loanAmount >= 1000000 && loanAmount < 3000000) {
      return loanAmount * 0.10; // 10% interest
    } else if (loanAmount >= 3000000) {
      return loanAmount * 0.14; // 14% interest
    }
    return 0.0;
  }

  // Public method to calculate interest
  static double calculateInterest(double loanAmount) {
    return _calculateInterest(loanAmount);
  }

  // Factory method to create a Loan instance from Firebase data
  factory Loan.fromMap(Map<dynamic, dynamic> map, String id) {
    return Loan(
      id: id,
      loanAmount: map['loanAmount']?.toDouble() ?? 0.0,
      loanPaid: map['loanPaid']?.toDouble() ?? 0.0,
      loanTaken: map['loanTaken']?.toDouble() ?? 0.0,
    );
  }

  // Converts a Loan object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'loanAmount': loanAmount,
      'loanPaid': loanPaid,
      'loanTaken': loanTaken,
      'interest': interest, // Include interest in the map
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
  double totalInterest; // Field to store total interest

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
  })  : totalPaid = loans.fold(0.0, (sum, loan) => sum + loan.loanPaid),
        totalTaken = loans.fold(0.0, (sum, loan) => sum + loan.loanTaken),
        totalInterest = loans.fold(0.0, (sum, loan) => sum + loan.interest),
        loanBalance = 0; // Initialize loanBalance to 0 (will be calculated in the constructor body)

  // Constructor body to calculate loan balance
  Member._init({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    required this.shares,
    this.noteDescription,
    required this.color,
    required this.loans,
    required this.totalPaid,
    required this.totalTaken,
    required this.totalInterest,
  }) : loanBalance = totalTaken - totalPaid + loans.fold(0.0, (sum, loan) => sum + loan.interest);

  factory Member.fromMap(Map<dynamic, dynamic> map, String id) {
    List<Loan> loans = [];

    // Populate the loans list if available
    if (map['loans'] != null) {
      for (var loanId in map['loans'].keys) {
        loans.add(Loan.fromMap(map['loans'][loanId], loanId));
      }
    }

    return Member._init(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      ward: map['ward'] ?? '',
      shares: map['shares'] ?? '',
      noteDescription: map['noteDescription'],
      color: Color(map['color'] ?? Colors.blue.value),
      loans: loans,  // Assign the loans list
      totalPaid: loans.fold(0.0, (sum, loan) => sum + loan.loanPaid),
      totalTaken: loans.fold(0.0, (sum, loan) => sum + loan.loanTaken),
      totalInterest: loans.fold(0.0, (sum, loan) => sum + loan.interest),
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
      'totalInterest': totalInterest, // Include totalInterest in the map
    };
  }
}
