class Payment {
  final String id;
  final int amount;
  final String method;
  final String receiver;
  final String status;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.method,
    required this.receiver,
    required this.status,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: json['amount'],
      method: json['method'],
      receiver: json['receiver'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
