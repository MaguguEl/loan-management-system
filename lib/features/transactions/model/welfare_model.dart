class Welfare {
  String id;
  double amount;

  Welfare({
    required this.id,
    required this.amount,
  });

  // Factory method to create a Welfare instance from Firebase data
  factory Welfare.fromMap(Map<dynamic, dynamic> map, String id) {
    return Welfare(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  // Converts a Welfare object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}