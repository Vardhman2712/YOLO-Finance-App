class Payment {
  final String id;
  final double amount;
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
      amount: (json['amount'] as num).toDouble(),
      method: json['method'],
      receiver: json['receiver'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'method': method,
      'receiver': receiver,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
