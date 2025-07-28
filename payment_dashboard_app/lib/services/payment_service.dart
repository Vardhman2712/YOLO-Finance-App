import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  final String baseUrl = 'http://10.0.2.2:3001'; // Android emulator-friendly

  Future<List<Payment>> fetchPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/payments'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Payment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch payments');
    }
  }

  Future<Map<String, dynamic>> fetchStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/payments/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'totalAmount': 0};
    }
  }

  Future<bool> createPayment(Payment payment) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payment.toJson()),
    );

    return response.statusCode == 201;
  }
}
