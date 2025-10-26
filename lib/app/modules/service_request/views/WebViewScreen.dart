// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:get/get.dart'; // Assuming you use GetX for navigation and controllers
//
// import '../../../../common/ui.dart';
// import '../../../providers/laravel_provider.dart';
// import '../../new_payment_ui/after_payment/DeclinePayment.dart';
// import '../controllers/RequestController.dart'; // Import your RequestController
// import '../../root/controllers/root_controller.dart'; // Import RootController
//
// class WebViewScreen extends StatefulWidget {
//   final int bookingId;
//   final String url;
//   final int orderId;
//   const WebViewScreen({Key key, @required this.url, @required this.bookingId, this.orderId}) : super(key: key);
//
//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   WebViewController _controller;
//   LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>(); // Get instance
//   RequestController _requestController = Get.find<RequestController>(); // Get instance
//   RootController _rootController = Get.find<RootController>(); // Get instance
//
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (WebView.platform is SurfaceAndroidWebView) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }
//
//   Future<void> verifyPaymentStatus(String bookingId) async {
//     print("Verifying payment status for bookingId: $bookingId");
//     try {
//       print("INSIDE TRY");
//       final responseData = await _laravelApiClient.getSSLCommerzStatus(bookingId);
//       print("Payment status response: $responseData");
//
//       // bool responseFromPayment = await _laravelApiClient.sendRequestAfterPayment(widget.orderId.toString());
//       // Navigator.pop(context);
//       //
//       // // UPDATE PAYMENT SCREEN
//       // if (responseFromPayment) {
//       //   // Show loading indicator for 2 seconds
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     const SnackBar(
//       //       content: Text('Request successful..................'),
//       //       duration: Duration(seconds: 1),
//       //     ),
//       //   );
//       //
//       //   // Navigate to AcceptPayment page after 2 seconds
//       //   await Future.delayed(const Duration(seconds: 2));
//       //   Get.find<RootController>().changePage(1);
//       // }
//       // else {
//       //   // Show snackbar with error message for 2 seconds
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     const SnackBar(
//       //       content: Text('Request NOT SUCCESSFUL',style: TextStyle(color: Colors.red),),
//       //       duration: Duration(seconds: 2),
//       //     ),
//       //   );
//       // }
//
//       // if (responseData != null && responseData['success'] == true) {
//       //   final status = responseData['data']['status']?.toString().toLowerCase();
//       //   print("Payment status: $status");
//       //
//       //   if (status == 'completed') {
//       //     print("Payment successful, triggering send request.");
//       //
//       //     await _laravelApiClient.sendRequestAfterPayment(bookingId);
//       //
//       //     Get.showSnackbar(
//       //       Ui.SuccessSnackBar(message: 'Payment successful!'),
//       //     );
//       //     // Navigate to a success page or back to home/bookings
//       //     _rootController.changePage(1); // Example: Navigate to bookings
//       //   } else {
//       //     print("Payment failed or is pending. Status: $status");
//       //     // Payment failed or is pending
//       //     Get.showSnackbar(
//       //       Ui.ErrorSnackBar(message: 'Payment failed or is pending. Status: ${status ?? 'Unknown'}'),
//       //     );
//       //     Navigator.pop(context); // Close WebView
//       //     Navigator.pushReplacement( // Use pushReplacement to avoid stacking pages
//       //       context,
//       //       MaterialPageRoute(
//       //         builder: (context) => DeclinePayment(),
//       //       ),
//       //     );
//       //   }
//       // } else {
//       //   print("Failed to get payment status from backend.");
//       //   Get.showSnackbar(
//       //     Ui.ErrorSnackBar(message: 'Failed to verify payment status.'),
//       //   );
//       //   Navigator.pop(context); // Close WebView
//       //   // Navigate to a failure page
//       //   Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (context) => DeclinePayment(),
//       //     ),
//       //   );
//       // }
//     }
//     catch (e) {
//       print("Error in verifyPaymentStatus: $e");
//       Get.showSnackbar(
//         Ui.ErrorSnackBar(message: 'An error occurred during verification.'),
//       );
//       Navigator.pop(context); // Close WebView
//       // Navigate to a failure page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DeclinePayment(),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(""),
//         centerTitle: true,
//         automaticallyImplyLeading: false, // Hide back button as we control navigation
//       ),
//       body: WebView(
//         initialUrl: widget.url,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller = webViewController;
//         },
//         navigationDelegate: (NavigationRequest request) {
//           if (request.url.contains('/payment/result')) {
//             Navigator.pop(context);
//
//             verifyPaymentStatus(widget.bookingId.toString());
//             return NavigationDecision.prevent;
//
//           }
//           verifyPaymentStatus(widget.bookingId.toString());
//           return NavigationDecision.navigate;
//         },
//         onPageFinished: (String url) {
//           print('Page finished loading: $url');
//           // You can potentially check the URL here as well to detect redirects
//         },
//         onWebResourceError: (WebResourceError error) {
//           print('Web resource error: ${error.description}');
//           // Handle web errors
//         },
//       ),
//     );
//   }
// }



// import 'dart:convert'; // For jsonDecode
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:get/get.dart';
// import '../../../../common/log_data.dart'; // Assuming you have this for logging
// import '../../../../common/ui.dart';
// import '../../../providers/laravel_provider.dart'; // Import your LaravelApiClient
// import '../../new_payment_ui/after_payment/DeclinePayment.dart';
// import '../controllers/RequestController.dart'; // Import your RequestController
// import '../../root/controllers/root_controller.dart'; // Import RootController
//
// class WebViewScreen extends StatefulWidget {
//   final String url;
//   final int orderId;
//   final int bookingId; // Added bookingId parameter
//   const WebViewScreen({Key key, @required this.url, @required this.bookingId, this.orderId}) : super(key: key);
//
//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   WebViewController _controller;
//   LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>(); // Get instance
//   RequestController _requestController = Get.find<RequestController>(); // Get instance
//   RootController _rootController = Get.find<RootController>(); // Get instance
//
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (WebView.platform is SurfaceAndroidWebView) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }
//
//   // Function to extract booking_id and status from the redirect URL
//   Map<String, String> _extractQueryParams(String url) {
//     try {
//       Uri uri = Uri.parse(url);
//       return uri.queryParameters;
//     } catch (e) {
//       print("Error parsing URL query parameters: $e");
//       return {};
//     }
//   }
//
//   // New function to verify payment status from your backend
//   Future<void> verifyPaymentStatus(String bookingId) async {
//     print("Verifying payment status for bookingId: $bookingId");
//     try {
//       print("INSIDE TRY");
//       final responseData = await _laravelApiClient.getSSLCommerzStatus(bookingId);
//       print("Payment status response: $responseData");
//
//
//       if (responseData != null && responseData['success'] == true) {
//         final status = responseData['data']['status']?.toString().toLowerCase();
//         print("Payment status: $status");
//
//         if (status == 'completed') {
//           print("Payment successful, triggering send request.");
//
//           await _laravelApiClient.sendRequestAfterPayment(bookingId);
//
//           Get.showSnackbar(
//             Ui.SuccessSnackBar(message: 'Payment successful!'),
//           );
//           // Navigate to a success page or back to home/bookings
//           _rootController.changePage(1); // Example: Navigate to bookings
//         } else {
//           print("Payment failed or is pending. Status: $status");
//           // Payment failed or is pending
//           Get.showSnackbar(
//             Ui.ErrorSnackBar(message: 'Payment failed or is pending. Status: ${status ?? 'Unknown'}'),
//           );
//           Navigator.pop(context); // Close WebView
//           Navigator.pushReplacement( // Use pushReplacement to avoid stacking pages
//             context,
//             MaterialPageRoute(
//               builder: (context) => DeclinePayment(),
//             ),
//           );
//         }
//       } else {
//         print("Failed to get payment status from backend.");
//         Get.showSnackbar(
//           Ui.ErrorSnackBar(message: 'Failed to verify payment status.'),
//         );
//         Navigator.pop(context); // Close WebView
//         // Navigate to a failure page
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DeclinePayment(),
//           ),
//         );
//       }
//     }
//     catch (e) {
//       print("Error in verifyPaymentStatus: $e");
//       Get.showSnackbar(
//         Ui.ErrorSnackBar(message: 'An error occurred during verification.'),
//       );
//       Navigator.pop(context); // Close WebView
//       // Navigate to a failure page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DeclinePayment(),
//         ),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Complete Payment"),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: WebView(
//         initialUrl: widget.url,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller = webViewController;
//         },
//         navigationDelegate: (NavigationRequest request) {
//           print("Navigating to: ${request.url}"); // Debug print for all navigation
//
//           if (request.url.contains('/payment/result')) {
//             Navigator.pop(context);
//
//             return NavigationDecision.prevent;
//           }
//           print("Detected payment result URL: ${request.url}");
//
//           // Extract booking_id and status from the URL
//           final queryParams = _extractQueryParams(request.url);
//           final status = queryParams['tran_type']?.toLowerCase();
//
//           if (widget.bookingId != null) {
//             print("Booking ID found: $widget.bookingId");
//
//             Navigator.pop(context);
//
//             if (status == 'success') { // If backend provides immediate success status
//               verifyPaymentStatus(widget.bookingId.toString()); // Verify to get definitive status
//             } else { // If status is 'failed' or missing, still verify
//               verifyPaymentStatus(widget.bookingId.toString());
//             }
//
//             return NavigationDecision.prevent; // Prevent the WebView from navigating to this URL
//           } else {
//             print("Booking ID not found in the redirect URL.");
//             // Handle cases where booking_id might be missing
//             Get.showSnackbar(
//               Ui.ErrorSnackBar(message: 'Payment completed, but could not verify booking details.'),
//             );
//             Navigator.pop(context); // Close WebView
//             // Navigate to a failure page or back to payment screen
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => DeclinePayment()),
//             );
//             return NavigationDecision.prevent;
//           }
//           //}
//         },
//         onPageFinished: (String url) {
//           print('Page finished loading: $url');
//         },
//         onWebResourceError: (WebResourceError error) {
//           print('Web resource error: ${error.description} (Code: ${error.errorCode})');
//           // Handle web errors, e.g., show an error message to the user
//           Get.showSnackbar(
//             Ui.ErrorSnackBar(message: 'Error loading payment page: ${error.description}'),
//           );
//           // If an error occurs, you might want to close the WebView and navigate to failure
//           Navigator.pop(context); // Close WebView
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => DeclinePayment()),
//           );
//         },
//       ),
//     );
//   }
// }



// Inside WebViewScreen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/RequestController.dart';
import '../../root/controllers/root_controller.dart';
import '../../new_payment_ui/after_payment/DeclinePayment.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final int bookingId;
  const WebViewScreen({Key key, @required this.url, @required this.bookingId}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController _controller;
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();
  RequestController _requestController = Get.find<RequestController>();
  RootController _rootController = Get.find<RootController>();

  bool _statusCheckTriggered = false;
  bool _isLoadingStatus = false;

  @override
  void initState() {
    super.initState();
    if (WebView.platform is SurfaceAndroidWebView) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  Map<String, String> _extractQueryParams(String url) {
    try {
      Uri uri = Uri.parse(url);
      print("Parsing URL for query params: $url");
      return uri.queryParameters;
    } catch (e) {
      print("Error parsing URL query parameters: $e");
      return {};
    }
  }

  Future<void> verifyPaymentStatus(String bookingId) async {
    if (_statusCheckTriggered) {
      print("Status check already triggered for bookingId: $bookingId. Skipping.");
      return;
    }
    _statusCheckTriggered = true;
    print("Verifying payment status for bookingId: $bookingId");
    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final responseData = await _laravelApiClient.getSSLCommerzStatus(bookingId);
      print("Payment status response from API: $responseData");

      if (responseData != null && responseData['success'] == true) {
        final status = responseData['data']['status']?.toString().toLowerCase();
        print("Payment status from API: $status");

        if (status == 'completed') {
          print("Payment confirmed COMPLETED from API. Triggering partner request.");
          // await _laravelApiClient.sendRequestAfterPayment(bookingId);
          Get.showSnackbar(Ui.SuccessSnackBar(message: 'Payment successful!'));
          Get.find<RootController>().changePage(1);
        } else {
          print("Payment status from API is not completed: $status");
          Get.showSnackbar(Ui.ErrorSnackBar(message: 'Payment ${status ?? 'unknown'}. Please check your order or contact support.'));
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclinePayment()));
        }
      } else {
        print("API call to getSSLCommerzStatus failed or returned success: false.");
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to verify payment status.'));
        Navigator.pop(context); // Close WebView if API failed
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclinePayment()));
      }
    } catch (e) {
      print("Exception in verifyPaymentStatus: $e");
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'An error occurred during verification.'));
      Navigator.pop(context); // Close WebView on error
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclinePayment()));
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Payment"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            navigationDelegate: (NavigationRequest request) {
              print("WebView attempting to navigate to: ${request.url}");

              if (request.url.startsWith("https://app.gen21.com.au/sslcommerz/success")) {
                print("navigationDelegate detected backend success redirect: ${request.url}");
                // We don't verify immediately here, we let onPageFinished handle it after the page loads.
                // We just prevent the navigation so the WebView doesn't change pages again.
                Navigator.pop(context);
                return NavigationDecision.prevent;
              }
              if (request.url.startsWith("https://app.gen21.com.au/sslcommerz/fail")) {
                print("navigationDelegate detected backend fail redirect: ${request.url}");
                // Close WebView and show failure. No verification needed, as backend indicated failure.
                Navigator.pop(context);
                Get.showSnackbar(Ui.ErrorSnackBar(message: 'Payment failed.'));
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclinePayment()));
                return NavigationDecision.prevent;
              }

              // Allow other navigations (SSLCommerz's internal pages, OTP, etc.)
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              print('WebView page FINISHED loading: $url');


              if (url.startsWith("https://app.gen21.com.au/sslcommerz/success")) {
                print("onPageFinished detected backend success URL: $url");
                print("Calling verifyPaymentStatus with bookingId: ${widget.bookingId}");
                Navigator.pop(context);
                verifyPaymentStatus(widget.bookingId.toString());
              } else if (url.startsWith("https://app.gen21.com.au/sslcommerz/fail")) {
                print("onPageFinished detected backend fail URL: $url");
                Navigator.pop(context); // Close WebView
                Get.showSnackbar(Ui.ErrorSnackBar(message: 'Payment failed. Please try again.'));
              } else if (url.startsWith("https://sandbox.sslcommerz.com/")) {
                print("Page is still on SSLCommerz domain: $url");
              }
            },
            onWebResourceError: (WebResourceError error) {
              print('WebView resource error: ${error.description} (Code: ${error.errorCode})');
              Get.showSnackbar(
                Ui.ErrorSnackBar(message: 'Error loading payment page: ${error.description}'),
              );
              Navigator.pop(context); // Close WebView on error
            },
          ),
          if (_isLoadingStatus)
            Center(
              child: Container(
                color: Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Verifying Payment Status...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}