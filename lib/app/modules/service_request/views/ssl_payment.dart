import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../../../common/ui.dart';
import '../../../models/booking_new_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../home/views/home2_view.dart';
import '../../new_payment_ui/after_payment/DeclinePayment.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/RequestController.dart';
import 'WebViewScreen.dart';
// import '../../service_request/controllers/RequestController.dart';

class sslpayment extends StatefulWidget {
  int bookingId;
  int orderId;
  String name;
  String address;
  String phoneNumber;
  String email;
  double amount;
  double totalPayableAmount;
  String serviceAmount;
  String service_info;
  sslpayment({Key key, @required this.bookingId, @required this.orderId, @required this.name, @required this.address, @required this.phoneNumber, @required this.email,
    @required this.amount, @required this.totalPayableAmount, @required this.serviceAmount, @required this.service_info}) : super(key: key);

  @override
  _sslpaymentState createState() => _sslpaymentState();
}


class _sslpaymentState extends State<sslpayment> {

  RequestController controller = Get.put(RequestController());
  final AddToCartController _addToCartController = Get.put(AddToCartController());

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

  final booking = BookingNew().obs;
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();

  List<String> randomCardLast4Digits = ['****1234', '****5678', '****4321'];

  final List<String> _months = [
    "Jan", "Feb", "Mar","Apr", "May", "Jun","Jul", "Aug", "Sep","Oct", "Nov", "Dec"
  ];

  @override
  void initState() {
    super.initState();
    callingSettings();
    fetchCardList();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    callingSettings();
  }

  Future<void> initiateSSLCommerzPaymentFlow() async {
    if (widget.bookingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Booking ID not found!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Initiating Payment...'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Call your backend for SSLCommerz initiation
      final paymentData = await _laravelApiClient.initiateSSLCommerzPayment(
          widget.bookingId.toString(), "mobile");

      Navigator.pop(context); // Close the dialog

      final gatewayUrl = paymentData['GatewayPageURL'] as String;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: gatewayUrl, bookingId: widget.bookingId, orderId: widget.orderId),
          // builder: (context) => WebViewScreen(url: gatewayUrl, bookingId: widget.bookingId),
        ),
      );

    } catch (e) {
      Navigator.pop(context); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initiating payment: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
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
      coupontAmount = 0.0;
      setState(() {});

    } else {
      print("Failed to fetch settings: ${response.reasonPhrase}");
    }
  }

  // List of years for dropdown
  final List<String> _years = [
    for (var i = 0; i < 11; i++) (DateTime.now().year + i).toString()
  ];


  TextEditingController textField1ControllerCardNumber = TextEditingController();
  TextEditingController textField1ControllerName = TextEditingController();
  TextEditingController textField1ControllerCCV = TextEditingController();

  // Dropdown menu values
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  // Selected values from dropdown menus
  String selectedMonth = '1';
  String selectedYear = DateTime.now().year.toString();

  String newSelectedMonth = '';
  String newSelectedYear = '';
  List<String> last4DigitsList = [];
  List<String> firstId = [];
  List<Map<String, dynamic>> cards2;
  Set<String> uniqueCardNumbers = {};
  String cardId = '0';

  String addLeadingZero(String value) {
    return value.length == 1 ? '0$value' : value;
  }

  // Function to handle button press
  Future<void> onPressedButton() async {
    // Get the data from text fields and dropdown menus

    String data1 = textField1ControllerCardNumber.text;
    String data2 = textField1ControllerName.text;
    String data3 = textField1ControllerCCV.text;

    // Display the data and dropdown menu values in a snackbar
    data1 = data1.replaceAll(' ', '');


    if (data1.isEmpty || data2. isEmpty || data3.isEmpty || selectedMonth.isEmpty || selectedYear.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all necessary forms"),
          duration: Duration(seconds: 2),
        ),
      );
      selectedMonth = '1';
      selectedYear = DateTime.now().year.toString();
      return false; // Return false as the request is not made
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Payment Ongoing........'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    selectedMonth = addLeadingZero(selectedMonth);
    selectedYear = selectedYear.substring(2);

    bool responseFromPayment = await _laravelApiClient.makePaymentRequest2(widget.bookingId.toString(), data1, data2, data3, selectedMonth, selectedYear);
    Navigator.pop(context);

    selectedMonth = '1';
    selectedYear = DateTime.now().year.toString();

    // UPDATE PAYMENT SCREEN
    if (responseFromPayment) {
      // Show loading indicator for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful..................'),
          duration: Duration(seconds: 1),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      onPressedButtonSendRequest();

    }
    else {
      // Show snackbar with error message for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PAYMENT NOT SUCCESSFUL',style: TextStyle(color: Colors.red),),
          duration: Duration(seconds: 2),
        ),
      );
    }

  }

  Future<void> onPressedButtonSendRequest() async {
    if (widget.orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No booking ID found.!"),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sending Request Ongoing........'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    bool responseFromPayment = await _laravelApiClient.sendRequestAfterPayment(widget.orderId.toString());

    Navigator.pop(context);

    // UPDATE PAYMENT SCREEN
    if (responseFromPayment) {
      // Show loading indicator for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request successful..................'),
          duration: Duration(seconds: 1),
        ),
      );

      // Navigate to AcceptPayment page after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      Get.find<RootController>().changePage(1);
    }
    else {
      // Show snackbar with error message for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request NOT SUCCESSFUL',style: TextStyle(color: Colors.red),),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  Future<void> onPressedButtonSelectCard() async {
    if (cardId == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select Card First"),
          duration: Duration(seconds: 2),
        ),
      );
      selectedMonth = '1';
      selectedYear = DateTime.now().year.toString();
      return false; // Return false as the request is not made
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Payment Ongoing........'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    bool responseFromPayment = await _laravelApiClient.makePaymentRequestSelectCard(widget.bookingId.toString(), cardId);

    Navigator.pop(context);


    // UPDATE PAYMENT SCREEN
    if (responseFromPayment) {
      // Show loading indicator for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful..................'),
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      onPressedButtonSendRequest();
    }
    else {
      // Show snackbar with error message for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PAYMENT NOT SUCCESSFUL',style: TextStyle(color: Colors.red),),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }



  // Function to get the numeric value of a month
  String getMonthValue(String month) {
    return (months.indexOf(month) + 1).toString();
  }

  Future<String>fetchCardList()async{
    String rr = await _laravelApiClient.cardList();

    List<dynamic> decodedResponse = json.decode(rr)["data"];
    List<Map<String, dynamic>> cards = List<Map<String, dynamic>>.from(decodedResponse);


    for (Map<String, dynamic> card in decodedResponse) {
      String cardNumber = card["cardNumber"];
      uniqueCardNumbers.add(cardNumber);
    }

    setState(() {
      cards2 = List.from(cards);;
    });
    // last4DigitsList = [];
    for (Map<String, dynamic> card in cards2) {
      String last4Digits = card["cardNumber"].substring(card["cardNumber"].length - 4);
      String fId = card["id"].toString();
      last4DigitsList.add(last4Digits);
      firstId.add(fId);
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var selectedOrderRequestType = controller.selectedOrderRequestType;
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Invoice Number:         ${widget.bookingId}", style: TextStyle(fontSize: 12)),
                      SizedBox(height: 2),
                      Text("Invoice Description: ${widget.email}", style: TextStyle(fontSize: 12)),
                      SizedBox(height: 2),
                      Text("Service info:                   ${widget.service_info}", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            // Payable Amount
            SizedBox(height: 30),
            Center(child: Text("Total Payable Amount", style: TextStyle(fontSize: 20))),

            SizedBox(height: 12),
            Text('Service Amount:             ${widget.amount}\৳(BDT)', style: TextStyle(fontSize: 12),),
            SizedBox(height: 2),
            Text('Service Charge:               $maintenanceChargeString.0\৳(BDT)', style: TextStyle(fontSize: 12),),
            SizedBox(height: 2),
            Text('---------------------------------', style: TextStyle(fontSize: 16),),
            Text('Coupon:                               -${coupontAmount}\৳(BDT)', style: TextStyle(fontSize: 12)),
            Text('---------------------------------', style: TextStyle(fontSize: 16),),
            Text('Total:                                        ${totalAmount - coupontAmount}\৳(BDT)', style: TextStyle(fontSize: 12)),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: initiateSSLCommerzPaymentFlow, // Call the new initiation method
                child: Text("Proceed to Payment"),
              ),
            ),

            // SizedBox(height: 20,),
            // // Card Details
            // SizedBox(height: 30),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           selectedOption = "NEW CARD";
            //         });
            //       },
            //       child: Text('NEW CARD'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         // fetchCardList();
            //         setState(() {
            //           selectedOption = "Select Card";
            //         });
            //       },
            //       child: Text('Select Card'),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16),
            //
            // // Display UI based on the selected option
            // if (selectedOption == 'NEW CARD')
            //   Column(
            //     children: [
            //       Center(child: Text("Card Details", style: TextStyle(fontSize: 20))),
            //       SizedBox(height: 8),
            //       TextFormField(
            //         controller: textField1ControllerCardNumber,
            //         keyboardType: TextInputType.number,
            //         inputFormatters: [
            //           FilteringTextInputFormatter.digitsOnly, // Allow only digits
            //           CardNumberFormatter(), // Apply card number formatting
            //           LengthLimitingTextInputFormatter(19), // Limit to 19 characters (max for credit cards)
            //         ],
            //         decoration: InputDecoration(
            //           labelText: 'Card Number',
            //           hintText: 'XXXX XXXX XXXX XXXX',
            //           border: OutlineInputBorder(),
            //         ),
            //         maxLength: 19,
            //         onChanged: (value) {}, // Handle input changes as needed
            //       ),
            //
            //       TextFormField(
            //         controller: textField1ControllerName,
            //         decoration: InputDecoration(
            //           labelText: 'Card Holder Name',
            //           border: OutlineInputBorder(),
            //         ),
            //         onChanged: (value) {}, // Handle input changes as needed
            //       ),
            //
            //       SizedBox(height: 20),
            //       Center(child: Text('Expiry Dates', style: TextStyle(fontSize: 12))),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //
            //           DropdownButton<String>(
            //             value: selectedMonth,
            //             onChanged: (String newValue) {
            //               setState(() {
            //                 selectedMonth = newValue;
            //               });
            //             },
            //             items: months.map<DropdownMenuItem<String>>((String value) {
            //               return DropdownMenuItem<String>(
            //                 value: getMonthValue(value),
            //                 child: Text(value),
            //               );
            //             }).toList(),
            //           ),
            //
            //
            //           SizedBox(height: 16),
            //           DropdownButton<String>(
            //             value: selectedYear,
            //             onChanged: (String newValue) {
            //               setState(() {
            //                 // Extract the last two characters as the new value
            //                 selectedYear = newValue;
            //               });
            //             },
            //             items: _years.map<DropdownMenuItem<String>>((String value) {
            //               return DropdownMenuItem<String>(
            //                 value: value,
            //                 child: Text(value),
            //               );
            //             }).toList(),
            //           ),
            //
            //         ],
            //       ),
            //       SizedBox(height: 10),
            //       TextFormField(
            //         controller: textField1ControllerCCV,
            //         keyboardType: TextInputType.number,
            //         inputFormatters: [
            //           FilteringTextInputFormatter.digitsOnly, // Allow only digits
            //         ],
            //         decoration: InputDecoration(
            //           labelText: 'CCV',
            //           border: OutlineInputBorder(),
            //         ),
            //         onChanged: (value) {}, // Handle input changes as needed
            //       ),
            //     ],
            //   ),
            // if(selectedOption == "Select Card")
            //   SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       children: cards2.map((card) {
            //         String last4Digits = card["cardNumber"].substring(card["cardNumber"].length - 4);
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //           child: GestureDetector(
            //             onTap: () {
            //               setState(() {
            //                 isCardSelected = true;
            //                 cardId = card["id"].toString();
            //               });
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 SnackBar(
            //                   content: Text('Your Card is selected. You can Pay now'),
            //                 ),
            //               );
            //             },
            //             child: Container(
            //               padding: EdgeInsets.all(8.0),
            //               decoration: BoxDecoration(
            //                 border: Border.all(color: isCardSelected ? Colors.orange : Colors.blue), // Change color to orange if card is selected
            //                 borderRadius: BorderRadius.circular(8.0),
            //               ),
            //               child: Text('****${last4Digits}'), // Display asterisks (*) before the last 4 digits
            //             ),
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //   ),
            SizedBox(height: 16),
            SizedBox(height: 10),
            if (selectedOption == 'NEW CARD')
              Row(
                children: [
                  SizedBox(width: 80),
                  Center(
                    child: ElevatedButton(
                      onPressed: onPressedButton,
                      child: Text("PAY Now"),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Home2View(),
                          ),
                        );
                      },
                      child: Text("Cancel"),
                    ),
                  ),],
              ),

            if (selectedOption == 'Select Card')
              Row(
                children: [
                  SizedBox(width: 80),
                  Center(
                    child: ElevatedButton(
                      onPressed: onPressedButtonSelectCard,
                      // onPressed: (){},
                      child: Text("PAY Now"),
                    ),
                  ),
                  SizedBox(width: 30,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Home2View(),
                          ),
                        );
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}


class CardNumberFormatter extends TextInputFormatter
{
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue previousValue, TextEditingValue nextValue) {
    var buffer = StringBuffer();
    for (int i = 0; i < nextValue.text.length; i++) {
      buffer.write(nextValue.text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != nextValue.text.length) {
        buffer.write(' '); // Insert space after every 4 digits
      }
    }
    return nextValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}

class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Add a space after every 4 characters
    if (newValue.text.length % 5 == 0 && newValue.text.length < 17) {
      return TextEditingValue(
        text: '${newValue.text} ',
        selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
      );
    }
    return newValue;
  }
}