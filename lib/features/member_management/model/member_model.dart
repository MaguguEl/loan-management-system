import 'dart:ui';
import 'dart:math';
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
  Color color;
  String? noteDescription;
  List<Loan> loans;
  double totalPaid;
  double totalTaken;
  double loanBalance;
  double totalInterest;
  List<Share> shares;
  double totalShares;
  List<Dividend> dividends;
  double totalDividends;
  List<Welfare> welfares;
  double totalWelfares;
  List<Penalty> penalties;
  double totalPenalties;

  Member({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    this.noteDescription,
    this.loans = const [],
    this.shares = const [],
    this.dividends = const [],
    this.welfares = const [],
    this.penalties = const [], required Color color,
  })  : totalPaid = loans.fold(0.0, (sum, loan) => sum + loan.loanPaid),
        totalTaken = loans.fold(0.0, (sum, loan) => sum + loan.loanTaken),
        totalInterest = loans.fold(0.0, (sum, loan) => sum + loan.interest),
        totalShares = shares.fold(0.0, (sum, share) => sum + share.amount),
        totalDividends = dividends.fold(0.0, (sum, dividend) => sum + dividend.amount),
        totalWelfares = welfares.fold(0.0, (sum, welfare) => sum + welfare.amount),
        totalPenalties = penalties.fold(0.0, (sum, penalty) => sum + penalty.amount),
        loanBalance = 0,
        color = getColorForMember(id);

  static Color getColorForMember(String memberId) {
    int hash = memberId.hashCode;
    Random random = Random(hash);
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Member._init({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.ward,
    this.noteDescription,
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
  }) : loanBalance = totalTaken - totalPaid + loans.fold(0.0, (sum, loan) => sum + loan.interest),
  color = getColorForMember(id);

  factory Member.fromMap(Map<dynamic, dynamic> map, String id) {
    List<Loan> loans = [];
    List<Share> shares = [];
    List<Dividend> dividends = [];
    List<Welfare> welfares = [];
    List<Penalty> penalties = [];

    // Populate the lists 
    if (map['loans'] != null) {
      for (var loanId in map['loans'].keys) {
        loans.add(Loan.fromMap(map['loans'][loanId], loanId));
      }
    }

    if (map['shares'] != null) {
      for (var shareId in map['shares'].keys) {
        shares.add(Share.fromMap(map['shares'][shareId], shareId));
      }
    }

    if (map['dividends'] != null) {
      for (var dividendId in map['dividends'].keys) {
        dividends.add(Dividend.fromMap(map['dividends'][dividendId], dividendId));
      }
    }

    if (map['welfares'] != null) {
      for (var welfareId in map['welfares'].keys) {
        welfares.add(Welfare.fromMap(map['welfares'][welfareId], welfareId));
      }
    }

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
      loans: loans,
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
      'color': getColorForMember(id).value, 
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
