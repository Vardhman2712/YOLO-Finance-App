class PaymentStats {
  final double totalAmount;
  final int totalCount;
  final int successCount;
  final int failedCount;
  final Map<String, int> methodStats;

  PaymentStats({
    required this.totalAmount,
    required this.totalCount,
    required this.successCount,
    required this.failedCount,
    required this.methodStats,
  });

  factory PaymentStats.fromJson(Map<String, dynamic> json) {
    return PaymentStats(
      totalAmount: json['totalAmount'].toDouble(),
      totalCount: json['totalCount'],
      successCount: json['successCount'],
      failedCount: json['failedCount'],
      methodStats: Map<String, int>.from(json['methodStats']),
    );
  }
}
