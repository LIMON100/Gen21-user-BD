import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/constant.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/data/responses/eway_initeate_sesponse.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../data/body/payment_body.dart';
import '../repositories/e_way_repository.dart';

// class EWayController extends GetxController {
//   WebViewController webView;
//   // PaymentRepository _paymentRepository;
//   EwayRepository _paymentRepository;
//
//   final url = "".obs;
//   // final bookingId = "".obs;
//   final progress = 0.0.obs;
//   final ewayInitiateResponse = new EwayInitiateResponse().obs;
//   final booking = BookingNew().obs;
//
//   // final isLoading = false.obs;
//
//   UserRepository _userRepository;
//   var user = new User().obs;
//
//   EWayController() {
//     // _paymentRepository = new PaymentRepository();
//     _paymentRepository = new EwayRepository();
//     _userRepository = new UserRepository();
//   }
//
//
//
//   @override
//   void onInit() async{
//     ewayInitiateResponse.value = Get.arguments['ewayInitiateResponse'] as EwayInitiateResponse;
//     url.value = ewayInitiateResponse.value.sharedPaymentUrl;
//     booking.value = Get.arguments['booking'] ;
//     print("kjsdnjkfna booking: ${booking.toString()}");
//     print("kjsdnjkfna url: $url");
//     await getUser();
//     // getUrl();
//     super.onInit();
//   }
//
//   // void getUrl() {
//   //   url.value = _paymentRepository.getPayPalUrl(booking.value);
//   // }
//
//   void showConfirmationIfSuccess() async{
//     // final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}payments/paypal";
//     // final _doneUrl = "https://secure-au.sandbox.ewaypayments.com/sharedpage/sharedpayment/Result";
//     // final _doneUrl = "sharedpage/sharedpayment/Result";
//     final _doneUrl = eWayDoneDoneUrl;
//     // if (url == _doneUrl) {
//     if (url.contains(_doneUrl)) {
//        await submitEWayPaymentResult();
//       // Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(50).id;
//       // if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
//       //   Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(50).id;
//       // }
//       // Get.toNamed(Routes.CONFIRMATION, arguments: {
//       //   'title': "Payment Successful".tr,
//       //   'long_message': "Your Payment is Successful".tr,
//       // });
//
//
//     }
//   }
//
//   void submitEWayPaymentResult() async{
//     PaymentBody paymentBody = PaymentBody(amount: "${booking.value.total_payable_amount}", description: "test description", userId: user.value.id, paymentMethodId: "13", paymentStatusId: "2", bookingId: booking.value.id);
//     // isLoading.value = true;
//     progress.value = .75;
//     var isSuccess = await _paymentRepository.submitEWayPaymentResult(bodyData: paymentBody);
//     // isLoading.value = false;
//     progress.value = 1;
//     print("jskdnfjaa ${isSuccess}");
//     if(isSuccess){
//       Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(50).id;
//       if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
//         Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(50).id;
//       }
//       Get.offNamed(Routes.CONFIRMATION, arguments: {
//         'title': "Payment Successful".tr,
//         'long_message': "Your Payment is Successful".tr,
//       });
//     }else{
//       Get.offNamed(Routes.PAYMENT_FAILED, arguments: {
//         'title': "Payment Failed".tr,
//         'long_message': "Something went wrong! Please contact to +0123456789".tr,
//       });
//     }
//
//
//   }
//
//   Future getUser() async {
//     try {
//       user.value = await _userRepository.getCurrentUser();
//     } catch (e) {
//       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//     }
//   }
// }


class EWayController extends GetxController {
  WebViewController webView;
  // PaymentRepository _paymentRepository;
  EwayRepository _paymentRepository;

  final url = "".obs;
  // final bookingId = "".obs;
  final progress = 0.0.obs;
  final ewayInitiateResponse = new EwayInitiateResponse().obs;
  final booking = BookingNew().obs;

  // final isLoading = false.obs;

  UserRepository _userRepository;
  var user = new User().obs;

  EWayController() {
    // _paymentRepository = new PaymentRepository();
    _paymentRepository = new EwayRepository();
    _userRepository = new UserRepository();
  }

  // Additional variables for tip handling
  final selectedTip = "No Tip".obs;
  final showAddTipField = false.obs;
  final tipAmountController = TextEditingController();
  final tipAmount = 0.0.obs;

  void setSelectedTip(String newValue) {
    selectedTip.value = newValue;
    // Show or hide the tip amount field based on the selected value
    showAddTipField.value = newValue == 'Yes, add tip';
  }

  void addTip() {
    // You can perform additional logic here if needed
    print('Adding tip: $tipAmount');
    // You can send the tip amount to your backend or perform other actions
  }
  @override
  void onInit() async{
    ewayInitiateResponse.value = Get.arguments['ewayInitiateResponse'] as EwayInitiateResponse;
    url.value = ewayInitiateResponse.value.sharedPaymentUrl;
    booking.value = Get.arguments['booking'] ;
    print("kjsdnjkfna booking: ${booking.toString()}");
    print("kjsdnjkfna url: $url");
    await getUser();
    // getUrl();
    super.onInit();
  }

  // void getUrl() {
  //   url.value = _paymentRepository.getPayPalUrl(booking.value);
  // }

  // void showConfirmationIfSuccess() async{
  //   // final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}payments/paypal";
  //   // final _doneUrl = "https://secure-au.sandbox.ewaypayments.com/sharedpage/sharedpayment/Result";
  //   // final _doneUrl = "sharedpage/sharedpayment/Result";
  //   final _doneUrl = eWayDoneDoneUrl;
  //   // if (url == _doneUrl) {
  //   if (url.contains(_doneUrl)) {
  //     await submitEWayPaymentResult();
  //     // Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(50).id;
  //     // if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
  //     //   Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(50).id;
  //     // }
  //     // Get.toNamed(Routes.CONFIRMATION, arguments: {
  //     //   'title': "Payment Successful".tr,
  //     //   'long_message': "Your Payment is Successful".tr,
  //     // });
  //   }
  // }
  void showConfirmationIfSuccess() async {
    final _doneUrl = eWayDoneDoneUrl;
    if (url.contains(_doneUrl)) {
      await submitEWayPaymentResult();
      if (selectedTip == 'Yes, add tip') {
        // Handle tip logic here
        if (tipAmountController.text.isNotEmpty) {
          double tipAmount = double.parse(tipAmountController.text);
          // Add the tip amount to your logic or store it as needed
        }
      }
    }
  }

  void submitEWayPaymentResult() async{
    PaymentBody paymentBody = PaymentBody(amount: "${booking.value.total_payable_amount}", description: "test description", userId: user.value.id, paymentMethodId: "13", paymentStatusId: "2", bookingId: booking.value.id);
    // isLoading.value = true;
    progress.value = .75;
    var isSuccess = await _paymentRepository.submitEWayPaymentResult(bodyData: paymentBody);
    // isLoading.value = false;
    progress.value = 1;
    print("jskdnfjaa ${isSuccess}");
    if(isSuccess){
      Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(50).id;
      if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
        Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(50).id;
      }
      Get.offNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }else{
      Get.offNamed(Routes.PAYMENT_FAILED, arguments: {
        'title': "Payment Failed".tr,
        'long_message': "Something went wrong! Please contact to +0123456789".tr,
      });
    }


  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
