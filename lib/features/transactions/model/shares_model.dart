class Share {
  String id;
  double amount;

  Share({
    required this.id,
    required this.amount,
  });

  factory Share.fromMap(Map<dynamic, dynamic> map, String id) {
    return Share(
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