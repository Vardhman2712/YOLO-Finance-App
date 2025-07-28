import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../services/payment_service.dart';

class NewPaymentDialog extends StatefulWidget {
  final VoidCallback onPaymentAdded;

  const NewPaymentDialog({super.key, required this.onPaymentAdded});

  @override
  State<NewPaymentDialog> createState() => _NewPaymentDialogState();
}

class _NewPaymentDialogState extends State<NewPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  String _method = 'UPI';
  String _receiver = '';
  bool _isLoading = false;

  final List<String> methods = ['UPI', 'Card', 'NetBanking', 'Cash'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final payment = Payment(
      id: '',
      amount: _amount,
      method: _method,
      receiver: _receiver,
      status: 'success',
      createdAt: DateTime.now(),
    );

    setState(() => _isLoading = true);
    final success = await PaymentService().createPayment(payment);
    setState(() => _isLoading = false);

    if (success) {
      widget.onPaymentAdded();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add payment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Payment'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Receiver'),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Required' : null,
              onSaved: (val) => _receiver = val!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val == null || double.tryParse(val) == null
                      ? 'Enter a valid number'
                      : null,
              onSaved: (val) => _amount = double.parse(val!),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Method'),
              value: _method,
              items: methods
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _method = val!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
