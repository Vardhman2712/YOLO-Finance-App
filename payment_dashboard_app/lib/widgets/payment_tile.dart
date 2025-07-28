import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class PaymentTile extends StatelessWidget {
  final Payment payment;

  const PaymentTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.payment, color: Colors.deepPurple),
        title: Text('₹${payment.amount} to ${payment.receiver}'),
        subtitle: Text('${payment.method} • ${payment.status}'),
        trailing: Text(
          '${payment.createdAt.toLocal().toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
