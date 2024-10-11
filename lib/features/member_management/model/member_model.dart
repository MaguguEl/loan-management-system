import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/transactions/model/dividend_model.dart';
import 'package:loan_management_system/features/transactions/model/loan_model.dart';
import 'package:loan_management_system/features/transactions/model/penalty_model.dart';
import 'package:loan_management_system/features/transactions/model/shares_model.dart';
import 'package:loan_management_system/features/transactions/model/welfare_model.dart';

class Member {
  String id;
  String name;
  String phone;
  String? email;
  String ward;
  String? noteDescription;
  Color color;
  List<Loan> loans;  // List to store loans
  double totalPaid;   // Total amount paid
  double totalTaken;  // Total amount taken
  double loanBalance; // Current loan balance
  double totalInterest; // Field to store total interest
  List<Share> shares;
  double totalShares;
  List<Dividend> dividends;  // List to store dividends
  double totalDividends;  // Total amount of dividends received
  List<Welfare> welfares;
  double totalWelfares;
  List<Penalty> penalties; // Declare penalties list
  double totalPenalties;

  Member({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    this.noteDescription,
    required this.color,
    this.loans = const [],  // Initialize the loans list
    this.shares= const [],
    this.dividends = const [],
    this.welfares = const [],
    this.penalties = const [], // Initialize penalties list
  })  : totalPaid = loans.fold(0.0, (sum, loan) => sum + loan.loanPaid),
        totalTaken = loans.fold(0.0, (sum, loan) => sum + loan.loanTaken),
        totalInterest = loans.fold(0.0, (sum, loan) => sum + loan.interest),
        totalShares = shares.fold(0.0, (sum, share) => sum + share.amount),
        totalDividends = dividends.fold(0.0, (sum, dividend) => sum + dividend.amount),
        totalWelfares = welfares.fold(0.0, (sum, welfare) => sum + welfare.amount),
        totalPenalties = penalties.fold(0.0, (sum, penalty) => sum + penalty.amount),
        loanBalance = 0; // Initialize loanBalance to 0 (will be calculated in the constructor body)

  // Constructor body to calculate loan balance
  Member._init({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    this.noteDescription,
    required this.color,
    required this.loans,
    required this.totalPaid,
    required this.totalTaken,
    required this.totalInterest,
    required this.shares,
    required this.dividends,
    required this.welfares,
    required this.totalShares,
    required this.totalDividends,
    required this.totalWelfares,
    required this.penalties,
    required this.totalPenalties,
  }) : loanBalance = totalTaken - totalPaid + loans.fold(0.0, (sum, loan) => sum + loan.interest);

  factory Member.fromMap(Map<dynamic, dynamic> map, String id) {
    List<Loan> loans = [];
    List<Share>  shares = [];
    List<Dividend> dividends = [];
    List<Welfare> welfares = [];
    List<Penalty> penalties = [];

    // Populate the loans list if available
    if (map['loans'] != null) {
      for (var loanId in map['loans'].keys) {
        loans.add(Loan.fromMap(map['loans'][loanId], loanId));
      }
    }

    // Populate the dividends list if available
    if (map['shares'] != null) {
      for (var shareId in map['shares'].keys) {
        shares.add(Share.fromMap(map['shares'][shareId], shareId));
      }
    }

    // Populate the dividends list if available
    if (map['dividends'] != null) {
      for (var dividendId in map['dividends'].keys) {
        dividends.add(Dividend.fromMap(map['dividends'][dividendId], dividendId));
      }
    }

    // Populate the welfare list if available
    if (map['welfares'] != null) {
      for (var welfareId in map['welfares'].keys) {
        welfares.add(Welfare.fromMap(map['welfares'][welfareId], welfareId));
      }
    }

    // Populate the penalty list if available
    if (map['penalties'] != null) {
      for (var penaltyId in map['penalties'].keys) {
        penalties.add(Penalty.fromMap(map['penalties'][penaltyId], penaltyId));
      }
    }

    return Member._init(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      ward: map['ward'] ?? '',
      noteDescription: map['noteDescription'],
      color: Color(map['color'] ?? Colors.blue.value),
      loans: loans,  // Assign the loans list
      shares: shares,  
      dividends: dividends,  
      welfares: welfares,
      penalties: penalties,
      totalPaid: loans.fold(0.0, (sum, loan) => sum + loan.loanPaid),
      totalTaken: loans.fold(0.0, (sum, loan) => sum + loan.loanTaken),
      totalInterest: loans.fold(0.0, (sum, loan) => sum + loan.interest),
      totalShares: shares.fold(0.0, (sum, share) => sum + share.amount),
      totalDividends: dividends.fold(0.0, (sum, dividend) => sum + dividend.amount),
      totalWelfares: welfares.fold(0.0, (sum, welfare) => sum + welfare.amount),
      totalPenalties: penalties.fold(0.0, (sum, penalty) => sum + penalty.amount),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'ward': ward,
      'noteDescription': noteDescription,
      'color': color.value,
      'loans': {for (var loan in loans) loan.id: loan.toMap()},
      'shares': {for (var share in shares) share.id: share.toMap()},
      'dividends': {for (var dividend in dividends) dividend.id: dividend.toMap()},
      'welfares': {for (var welfare in welfares) welfare.id: welfare.toMap()},
      'penalties': {for (var penalty in penalties) penalty.id: penalty.toMap()},
      'totalPaid': totalPaid,
      'totalTaken': totalTaken,
      'loanBalance': loanBalance,
      'totalInterest': totalInterest,
      'totalShares': totalShares,
      'totalDividends': totalDividends,
      'totalWelfares': totalWelfares,
      'totalPenalties': totalPenalties,
    };
  }
}