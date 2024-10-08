import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/model/dividend_model.dart';
import 'package:loan_management_system/features/transactions/model/shares_model.dart';
import 'package:loan_management_system/features/transactions/model/welfare_model.dart';
import 'package:loan_management_system/features/transactions/model/penalty_model.dart';

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
  List<Loan> loans; // List to store loans
  double totalPaid; // Total amount paid
  double totalTaken; // Total amount taken
  double loanBalance; // Current loan balance
  double totalInterest; // Field to store total interest
  List<Dividend> dividends; // List to store dividends
  double totalDividends; // Total amount of dividends received
  List<Welfare> welfareList; // List to store welfare contributions
  double totalWelfare; // Total amount of welfare contributions
  List<Penalty> penaltyList; // List to store penalties
  double totalPenalties; // Total amount of penalties
  List<Shares> sharesList; // List to store shares contributions
  double totalShares; // Total amount of shares

  Member({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    required this.shares,
    this.noteDescription,
    required this.color,
    this.loans = const [], // Initialize the loans list
    this.dividends = const [], // Initialize the dividends list
    this.welfareList = const [], // Initialize the welfare list
    this.penaltyList = const [], // Initialize the penalty list
    this.sharesList = const [], // Initialize the shares list
  })  : totalPaid = loans.fold(0.0, (sum, loan) => sum + loan.loanPaid),
        totalTaken = loans.fold(0.0, (sum, loan) => sum + loan.loanTaken),
        totalInterest = loans.fold(0.0, (sum, loan) => sum + loan.interest),
        totalDividends = dividends.fold(0.0, (sum, dividend) => sum + dividend.amount),
        totalWelfare = welfareList.fold(0.0, (sum, welfare) => sum + welfare.amount),
        totalPenalties = penaltyList.fold(0.0, (sum, penalty) => sum + penalty.amount),
        totalShares = sharesList.fold(0.0, (sum, share) => sum + share.amount),
        loanBalance = 0; // Calculate loan balance

  factory Member.fromMap(Map<dynamic, dynamic> map, String id) {
    List<Loan> loans = [];
    List<Dividend> dividends = [];
    List<Welfare> welfareList = [];
    List<Penalty> penaltyList = [];
    List<Shares> sharesList = [];

    // Populate the loans list if available
    if (map['loans'] != null) {
      for (var loanId in map['loans'].keys) {
        loans.add(Loan.fromMap(map['loans'][loanId], loanId));
      }
    }

    // Populate the dividends list if available
    if (map['dividends'] != null) {
      for (var dividendId in map['dividends'].keys) {
        dividends.add(Dividend.fromMap(map['dividends'][dividendId], dividendId));
      }
    }

    // Populate the welfare list if available
    if (map['welfare'] != null) {
      for (var welfareId in map['welfare'].keys) {
        welfareList.add(Welfare.fromMap(map['welfare'][welfareId], welfareId));
      }
    }

    // Populate the penalty list if available
    if (map['penalties'] != null) {
      for (var penaltyId in map['penalties'].keys) {
        penaltyList.add(Penalty.fromMap(map['penalties'][penaltyId], penaltyId));
      }
    }

    // Populate the shares list if available
    if (map['shares'] != null) {
      for (var shareId in map['shares'].keys) {
        sharesList.add(Shares.fromMap(map['shares'][shareId], shareId));
      }
    }

    return Member(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      ward: map['ward'] ?? '',
      shares: map['shares'] ?? '',
      noteDescription: map['noteDescription'],
      color: Color(map['color'] ?? Colors.blue.value),
      loans: loans,
      dividends: dividends,
      welfareList: welfareList,
      penaltyList: penaltyList,
      sharesList: sharesList,
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
      'loans': {for (var loan in loans) loan.id: loan.toMap()},
      'dividends': {for (var dividend in dividends) dividend.id: dividend.toMap()},
      'welfare': {for (var welfare in welfareList) welfare.id: welfare.toMap()},
      'penalties': {for (var penalty in penaltyList) penalty.id: penalty.toMap()},
      'shares': {for (var share in sharesList) share.id: share.toMap()},
      'totalPaid': totalPaid,
      'totalTaken': totalTaken,
      'loanBalance': loanBalance,
      'totalInterest': totalInterest,
      'totalWelfare': totalWelfare,
      'totalPenalties': totalPenalties,
      'totalDividends': totalDividends,
      'totalShares': totalShares,
    };
  }
}

// Example models for Shares, Welfare, and Penalty following the Dividend model structure
class Shares {
  String id;
  double amount;

  Shares({
    required this.id,
    required this.amount,
  });

  factory Shares.fromMap(Map<dynamic, dynamic> map, String id) {
    return Shares(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}

class Welfare {
  String id;
  double amount;

  Welfare({
    required this.id,
    required this.amount,
  });

  factory Welfare.fromMap(Map<dynamic, dynamic> map, String id) {
    return Welfare(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}

class Penalty {
  String id;
  double amount;

  Penalty({
    required this.id,
    required this.amount,
  });

  factory Penalty.fromMap(Map<dynamic, dynamic> map, String id) {
    return Penalty(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}
