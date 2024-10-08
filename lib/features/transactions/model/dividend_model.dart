class Dividend {
  String id;
  double amount;

  Dividend({
    required this.id,
    required this.amount,
  });

  // Factory method to create a Dividend instance from Firebase data
  factory Dividend.fromMap(Map<dynamic, dynamic> map, String id) {
    return Dividend(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  // Converts a Dividend object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}