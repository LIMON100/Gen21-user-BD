import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../../services/settings_service.dart';
import '../../service_request/controllers/RequestController.dart';

class payrequest extends StatefulWidget {
  String name;
  String address;
  String phoneNumber;
  String email;
  double amount;
  double totalPayableAmount;
  String serviceAmount;
  payrequest({Key key, @required this.name, @required this.address, @required this.phoneNumber, @required this.email,
    @required this.amount, @required this.totalPayableAmount, @required this.serviceAmount}) : super(key: key);

  @override
  _payrequesttState createState() => _payrequesttState();
}


class _payrequesttState extends State<payrequest> {

  bool isLoading = true;

  String cardNumber = '';
  String cardHolderName = '';
  String expiryMonth = 'Jan';
  String expiryYear = '2023';
  String cvv = '';
  String selectedOption = "";
  String selectedCard = '';
  String couponTest = '';
  String maintenanceChargeString = '10';
  double totalAmount = 0.0;
  double coupontAmount = 0.0;
  bool isCardSelected = false;


  List<String> randomCardLast4Digits = ['****1234', '****5678', '****4321'];

  final List<String> _months = [
    "Jan", "Feb", "Mar","Apr", "May", "Jun","Jul", "Aug", "Sep","Oct", "Nov", "Dec"
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    callingSettings();

  }


  void callingSettings() async {
    final response = await http.get(Uri.parse('https://app.gen21.com.au/api/settings'));


    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Access the maintenance_charge value
      maintenanceChargeString = jsonResponse['data']['maintenance_charge'];
      double maintenanceCharge = double.tryParse(maintenanceChargeString) ?? 0.0;
      double prevousAmount = double.tryParse(widget.amount.toString()) ?? 0.0;
      double couponValue = double.tryParse(widget.totalPayableAmount.toString()) ?? 0.0;

      totalAmount = (prevousAmount + maintenanceCharge) as double;
      coupontAmount = prevousAmount - couponValue;
      setState(() {});

    } else {
      print("Failed to fetch settings: ${response.reasonPhrase}");
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Service Payment"),
        automaticallyImplyLeading: false,
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Image.asset('assets/icon/iconpayment.png', height: 200, width: screenWidth),

            // Customer Details
            SizedBox(height: 20),
            Center(child: Text("Customer Details", style: TextStyle(fontSize: 20))),
            SizedBox(height: 16),
            Text("Name:         ${widget.name}", style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text("Email:          ${widget.email}", style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text("Address:   ${widget.address}", style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text("Mobile:       ${widget.phoneNumber}", style: TextStyle(fontSize: 12)),

            // Invoice Info
            SizedBox(height: 30),
            Center(child: Text("Product Invoice Information ", style: TextStyle(fontSize: 20))),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    Text("Invoice Description: ${widget.email}", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 2),
                    // Text("Service info:                   ${_booking.value.eService.name}", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            // Payable Amount
            SizedBox(height: 30),
            Center(child: Text("Total Payable Amount", style: TextStyle(fontSize: 20))),

            SizedBox(height: 12),
            Text('Service Amount:             ${widget.amount}\$(AUD)', style: TextStyle(fontSize: 12),),
            SizedBox(height: 2),
            Text('Service Charge:               $maintenanceChargeString.0\$(AUD)', style: TextStyle(fontSize: 12),),
            SizedBox(height: 2),
            Text('---------------------------------', style: TextStyle(fontSize: 16),),

            // if (_booking.value.coupon == 'null')
            //   Text('Total:                                       ${totalAmount}\$(AUD)', style: TextStyle(fontSize: 12)),
            // if (_booking.value.coupon != 'null')
            //   Text('Sub Total:                              ${totalAmount}\$(AUD)', style: TextStyle(fontSize: 12)),
            Text('Coupon:                               -${coupontAmount}\$(AUD)', style: TextStyle(fontSize: 12)),
            Text('---------------------------------', style: TextStyle(fontSize: 16),),
            Text('Total:                                        ${totalAmount - coupontAmount}\$(AUD)', style: TextStyle(fontSize: 12)),

            // controller.isSubmitOrderLoading.value == true
            //     ? CircularProgressIndicator()
            //
            //     :InkWell(
            //   onTap: () {
            //     if (Get.find<SettingsService>()
            //         .address
            //         .value
            //         .isUnknown()) {
            //       Get.showSnackbar(Ui.ErrorSnackBar(
            //           message: "Please set your location"));
            //     }
            //     else {
            //       if (selectedOrderRequestType !=
            //           "Choose Provider Manually") {
            //         controller.submitBookingRequest(
            //             _addToCartController.addToCartData);
            //       }
            //       if (selectedOrderRequestType ==
            //           "Choose Provider Manually" &&
            //           controller.providersData.length > 0) {
            //         // controller.validateManualBookingRequest(
            //         //     _addToCartController.addToCartData);
            //       }
            //     }
            //   },
            //   child: Container(
            //     padding: EdgeInsets.only(
            //         left: 20, right: 20, top: 10, bottom: 10),
            //     decoration: BoxDecoration(
            //       color: Get.theme.colorScheme.secondary,
            //       borderRadius: BorderRadius.all(Radius.circular(20)),
            //     ),
            //     child: Text("Send Request",
            //         style: (TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white))),
            //   ),
            // )

          ],
        ),
      ),
    );
  }
}
