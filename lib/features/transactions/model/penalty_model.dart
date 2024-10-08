class Penalty {
  String id;
  double amount;

  Penalty({
    required this.id,
    required this.amount,
  });

  // Factory method to create a Penalty instance from Firebase data
  factory Penalty.fromMap(Map<dynamic, dynamic> map, String id) {
    return Penalty(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  // Converts a Penalty object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}