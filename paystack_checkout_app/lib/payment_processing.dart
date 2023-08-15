import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paystack_checkout_app/payment_success.dart';

import 'checkout_page.dart';

class PyamentProcessing extends StatefulWidget {
  final String reference;
  const PyamentProcessing({super.key, required this.reference});

  @override
  State<PyamentProcessing> createState() => _PyamentProcessingState();
}

class _PyamentProcessingState extends State<PyamentProcessing> {
  void verifyOnServer() async {
    String token = 'YOUR TOKEN';
    final paymentRef = widget.reference;
    String url = 'https://api.paystack.co/transaction/verify/$paymentRef';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    final Map body = json.decode(response.body);
    if (body['data']['status'] == 'success') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PaymentSuccess(successMessage: 'Payment was successful')),
          ModalRoute.withName('/'));
    } else {
      AlertDialog(
        title: Text("Payment"),
        content: Column(children: [
          Divider(),
          Text("Payment was not successful"),
          Spacer(),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckoutPage()));
              },
              child: Text("Try Again"))
        ]),
      );
    }
  }

  @override
  void initState() {
    verifyOnServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
