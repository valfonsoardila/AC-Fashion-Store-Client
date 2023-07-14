import 'package:flutter/material.dart';

class PaymentGateway extends StatefulWidget {
  final compra;
  PaymentGateway({super.key, this.compra});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Payment Gateway',
            ),
          ],
        ),
      ),
    );
  }
}
