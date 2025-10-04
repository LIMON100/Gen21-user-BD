import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyScreen2 extends StatefulWidget {
  @override
  _MyScreen2State createState() => _MyScreen2State();
}

class _MyScreen2State extends State<MyScreen2> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryMonth = 'Jan';
  String expiryYear = '2023';
  String cvv = '';

  // List of years for dropdown
  final List<String> _years = [
    for (var i = 0; i < 11; i++) (DateTime.now().year + i).toString()
  ];

  TextEditingController textField1ControllerCardNumber = TextEditingController();
  TextEditingController textField1ControllerName = TextEditingController();
  TextEditingController textField1ControllerCCV = TextEditingController();

  // Dropdown menu values
  List<String> months = ['Month','January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  // Selected values from dropdown menus
  String selectedMonth = 'Month';
  String selectedYear = DateTime.now().year.toString();

  String selectedOption = ""; // Default option

  List<String> randomCardLast4Digits = ['****1234', '****5678', '****4321']; // Example random card data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row of buttons to switch between "NEW CARD" and "Select Card" options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedOption = "NEW CARD";
                    });
                  },
                  child: Text('NEW CARD'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedOption = "Select Card";
                    });
                  },
                  child: Text('Select Card'),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Display UI based on the selected option
            if (selectedOption == 'NEW CARD')
              Column(
                children: [
                  Center(child: Text("Card Details", style: TextStyle(fontSize: 20))),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: textField1ControllerCardNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                      CardNumberFormatter(), // Apply card number formatting
                      LengthLimitingTextInputFormatter(19), // Limit to 19 characters (max for credit cards)
                    ],
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 19,
                    onChanged: (value) {}, // Handle input changes as needed
                  ),

                  TextFormField(
                    controller: textField1ControllerName,
                    decoration: InputDecoration(
                      labelText: 'Card Holder Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {}, // Handle input changes as needed
                  ),

                  SizedBox(height: 20),
                  Center(child: Text('Expiry Dates', style: TextStyle(fontSize: 12))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        value: selectedMonth,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedMonth = newValue;
                          });
                        },
                        items: months.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      // Dropdown menu for YEAR
                      DropdownButton<String>(
                        value: selectedYear,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                        items: _years.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: textField1ControllerCCV,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                    decoration: InputDecoration(
                      labelText: 'CCV',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {}, // Handle input changes as needed
                  ),
                ],
              ),
            if(selectedOption == "Select Card")
              Column(
                children: [
                  Center(child: Text('Select Card', style: TextStyle(fontSize: 20))),
                  SizedBox(height: 8),
                  // Display last 4 digits of random cards
                  for (String cardLast4Digits in randomCardLast4Digits)
                    ListTile(
                      title: Text(cardLast4Digits),
                      onTap: () {
                        // Handle card selection as needed
                      },
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