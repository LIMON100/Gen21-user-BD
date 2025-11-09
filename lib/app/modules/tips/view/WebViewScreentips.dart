import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../../new_payment_ui/after_payment/AfterTipsPayment.dart';
import '../../rating/controllers/provider_rating_controller.dart';
import '../../service_request/controllers/RequestController.dart';
import '../../root/controllers/root_controller.dart';

class WebViewScreentips extends StatefulWidget {
  final String url;
  final String bookingId;
  const WebViewScreentips({Key key, @required this.url, @required this.bookingId}) : super(key: key);

  @override
  _WebViewScreentipsState createState() => _WebViewScreentipsState();
}

class _WebViewScreentipsState extends State<WebViewScreentips> {
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
          Get.showSnackbar(Ui.SuccessSnackBar(message: 'Tips Payment successful!'));

          // FULL BOOKING COMPLETE
          await Future.delayed(const Duration(seconds: 2));
          Get.find<ProviderRatingController>().addTipsProviderReviewTest();
          print("AFTER PROVIDER");
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => AfterTipsPayment(),
          //   ),
          // );

          Get.find<RootController>().changePage(1);
        }
        else {
          print("Payment status from API is not completed: $status");
          Get.showSnackbar(Ui.ErrorSnackBar(message: 'Payment ${status ?? 'unknown'}. Please check your order or contact support.'));
        }
      }
      else {
        print("API call to getSSLCommerzStatus failed or returned success: false.");
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to verify payment status.'));
        Navigator.pop(context); // Close WebView if API failed
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclinePayment()));
      }
    }
    catch (e) {
      print("Exception in verifyPaymentStatus: $e");
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'An error occurred during verification.'));
      Navigator.pop(context); // Close WebView on error
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclinePayment()));
    }
    finally {
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
        title: Text(""),
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