import 'package:flutter/material.dart';

class CustomerSupportPage extends StatefulWidget {
  // Optional: Add a routeName for easy navigation if using named routes
  static const String routeName = '/customer-support';

  // const CustomerSupportPage({super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  // Controller to manage the text field's content
  final TextEditingController _problemController = TextEditingController();

  // Variable to store the submitted text
  String _submittedText = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _problemController.dispose();
    super.dispose();
  }

  void _submitProblem() {
    // Use setState to update the UI when the state changes
    setState(() {
      _submittedText = _problemController.text;
    });

    // --- Placeholder for actual submission logic ---
    // In a real app, you would send _submittedText to your backend API,
    // a chat service, email, etc. here.
    print("Submission Button Clicked!");
    print("User Problem: $_submittedText");
    // You might want to show a confirmation dialog or navigate away
    // after successful submission in a real app.
    // For now, we just display it below.
    // You could also clear the text field after submission if desired:
    // _problemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support'),
        backgroundColor: Colors.orange, // Optional: Customize AppBar color
        foregroundColor: Colors.white,      // Optional: Customize AppBar text/icon color
      ),
      body: Padding(
        // Add padding around the content
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Align children to the start of the column
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Describe your issue:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0), // Spacing

            // Text Field for user input
            TextField(
              controller: _problemController,
              decoration: const InputDecoration(
                hintText: 'Please provide details about the problem...',
                border: OutlineInputBorder(), // Add a border
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              maxLines: 5, // Allow multiple lines for detailed descriptions
              keyboardType: TextInputType.multiline, // Suggest multiline keyboard
            ),
            const SizedBox(height: 20.0), // Spacing

            // Submission Button
            ElevatedButton(
              onPressed: _submitProblem, // Call the submit function on press
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button background color
                foregroundColor: Colors.white,      // Button text color
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: const Text('Submit Problem'),
            ),
            const SizedBox(height: 30.0), // Spacing before displaying the text

            // --- Display Area for Submitted Text ---
            // Only show this section if text has been submitted
            if (_submittedText.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You submitted:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey[400])
                    ),
                    child: Text(
                      _submittedText,
                      style: const TextStyle(fontSize: 14.0),
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