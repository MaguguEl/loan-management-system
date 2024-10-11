class Loan {
  String id;
  double loanAmount;
  double loanPaid;
  double loanTaken;
  double interest;

  Loan({
    required this.id,
    required this.loanAmount,
    required this.loanPaid,
    required this.loanTaken,
  }) : interest = _calculateInterest(loanAmount); 

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
      'interest': interest,
    };
  }
}