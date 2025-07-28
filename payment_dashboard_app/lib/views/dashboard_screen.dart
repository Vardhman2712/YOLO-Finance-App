import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/payment.dart';
import '../services/payment_service.dart';
import 'new_payment_dialog.dart';
import '../main.dart';
import '../widgets/revenue_chart.dart';

class DashboardScreen extends StatefulWidget {
  final String role; // 'admin' or 'viewer'
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<double> _weeklyRevenue = [
    1500,
    2200,
    1800,
    2600,
    1900,
    2500,
    3000,
  ];
  late Future<List<Payment>> _futurePayments;
  List<Payment> payments = [];
  double totalAmount = 0;
  String _userRole = 'viewer';
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchUserRole(); // 🔐 get user role from SharedPreferences
    _fetchPayments();
    _fetchStats();
    _futurePayments = PaymentService().fetchPayments();
  }

  Future<void> _fetchPayments() async {
    final data = await PaymentService().fetchPayments();
    setState(() {
      payments = data;
    });
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT');
    }

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    return jsonDecode(payload);
  }

  Future<void> _fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt') ?? '';
    if (jwt.isNotEmpty) {
      final decoded = parseJwt(jwt);
      setState(() {
        _userRole = decoded['role'] ?? 'viewer';
      });
    }
  }

  Future<void> _fetchStats() async {
    final stats = await PaymentService().fetchStats();
    setState(() {
      totalAmount = stats['totalAmount']?.toDouble() ?? 0;
    });
  }

  Future<void> _refreshData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');

    final url = Uri.parse('http://10.0.2.2:3001/payments/');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final payments = jsonData.map((item) => Payment.fromJson(item)).toList();

      setState(() {
        _futurePayments = Future.value(payments);
      });
    } else {
      throw Exception('Failed to fetch payments');
    }
  }

  Icon _getMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'upi':
        return const Icon(Icons.qr_code, color: Colors.blue);
      case 'card':
        return const Icon(Icons.credit_card, color: Colors.purple);
      case 'netbanking':
        return const Icon(Icons.account_balance, color: Colors.green);
      default:
        return const Icon(Icons.payments, color: Colors.grey);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: _getMethodIcon(payment.method),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.receiver,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.method,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${payment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(payment.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    payment.status,
                    style: TextStyle(
                      color: _getStatusColor(payment.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(payment.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Payment>>(
        future: _futurePayments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading data"));
          }

          final payments = snapshot.data!;
          final totalAmount = payments.fold<double>(
            0,
            (sum, item) => sum + item.amount,
          );

          return Column(
            children: [
              // 🔐 Show warning if viewer
              if (_userRole == 'viewer') ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.shade100,
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        "You are in read-only mode",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // 💰 Payment Summary Cards
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: Row(
                  children: [
                    _buildSummaryCard(
                      context: context,
                      title: 'Total Payments',
                      value: '₹${totalAmount.toStringAsFixed(2)}',
                      icon: Icons.payments,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      context: context,
                      title: 'Transactions',
                      value: payments.length.toString(),
                      icon: Icons.list_alt,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              if (widget.role == 'admin') RevenueChart(revenueByDay: _weeklyRevenue),

              // 📄 Transaction List
              Expanded(
                child: payments.isEmpty
                    ? const Center(child: Text('No transactions found'))
                    : ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          return _buildPaymentCard(payments[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: widget.role == 'admin'
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                      NewPaymentDialog(onPaymentAdded: _fetchPayments),
                );
              },
            )
          : null,
    );
  }
}
