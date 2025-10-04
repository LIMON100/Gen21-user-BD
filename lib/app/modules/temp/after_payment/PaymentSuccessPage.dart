import 'package:flutter/material.dart';


class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Payment Successful"),
        // ),
        body: Center(
          child: Text(
            "Payment successfully",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}