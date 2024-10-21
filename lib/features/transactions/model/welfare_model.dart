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