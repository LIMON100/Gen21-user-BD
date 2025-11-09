// // Create a new file, e.g., lib/app/global_widgets/otp_input_dialog.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../../../common/ui.dart';
// import '../../providers/laravel_provider.dart'; // For getInputDecoration and general styling
//
// class OtpInputDialog extends StatefulWidget {
//   final String title;
//   final String hintText;
//   final String confirmButtonText;
//   final int bookingId; // Need bookingId to pass to the API
//   final Function(bool success) onConfirmResult; // Callback to inform parent of success/failure
//
//   const OtpInputDialog({
//     Key key,
//     this.title = "Enter OTP",
//     this.hintText = "Enter your OTP",
//     this.confirmButtonText = "Confirm",
//     @required this.bookingId,
//     @required this.onConfirmResult, Future<Null> Function(String otp) onConfirm, // This is the new callback for API result
//   }) : super(key: key);
//
//   @override
//   _OtpInputDialogState createState() => _OtpInputDialogState();
// }
//
// class _OtpInputDialogState extends State<OtpInputDialog> {
//   final TextEditingController _otpController = TextEditingController();
//   bool _isLoading = false;
//   LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>(); // Get instance
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   void _handleConfirm() async {
//     if (_otpController.text.trim().isEmpty) {
//       Get.snackbar("Input Error", "Please enter the OTP.");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // Call the API to confirm OTP
//       bool otpIsValid = await _laravelApiClient.sendBookingOtpConfirmation(
//         widget.bookingId.toString(),
//       );
//
//       // Notify the parent widget about the result (true for success, false for failure)
//       widget.onConfirmResult(otpIsValid);
//
//       // The dialog will be dismissed by the parent widget's navigation or UI update logic.
//       // If the parent widget navigates away immediately, this dispose will be fine.
//       // If the parent stays, it needs to manage the dialog dismissal.
//
//     } catch (e) {
//       print("Error during OTP confirmation handler: $e");
//       Get.snackbar("Error", "Failed to confirm OTP: ${e.toString()}");
//       // Notify parent of failure
//       widget.onConfirmResult(false); // Indicate failure
//     } finally {
//       // Hide loader if the widget is still mounted and dialog is not dismissed
//       if (mounted && mounted) { // Double mounted check for safety
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(widget.title.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               decoration: Ui.getInputDecoration(hintText: widget.hintText.tr),
//               cursorColor: Get.theme.focusColor,
//               autofocus: true,
//               onSubmitted: (value) => _handleConfirm(),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close dialog on cancel
//                   },
//                   child: Text("Cancel".tr, style: TextStyle(color: Colors.grey)),
//                 ),
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : ElevatedButton(
//                   onPressed: _handleConfirm,
//                   child: Text(widget.confirmButtonText.tr),
//                   style: ElevatedButton.styleFrom(
//                     primary: Get.theme.colorScheme.secondary,
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }