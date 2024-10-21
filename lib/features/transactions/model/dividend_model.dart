class Dividend {
  String id;
  double amount;

  Dividend({
    required this.id,
    required this.amount,
  });

  factory Dividend.fromMap(Map<dynamic, dynamic> map, String id) {
    return Dividend(
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