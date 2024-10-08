class Share {
  String id;
  double amount;

  Share({
    required this.id,
    required this.amount,
  });

  // Factory method to create a Share instance from Firebase data
  factory Share.fromMap(Map<dynamic, dynamic> map, String id) {
    return Share(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  // Converts a Share object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
    };
  }
}