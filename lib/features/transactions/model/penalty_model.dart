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