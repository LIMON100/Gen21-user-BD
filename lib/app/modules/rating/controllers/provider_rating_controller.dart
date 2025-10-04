import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';

class ProviderRatingController extends GetxController {
  // final booking = Booking().obs;
  final review = new Review(rate: 0).obs;
  // BookingRepository _bookingRepository;
  EProviderRepository _eProviderRepository;
  final eProvider = EProvider().obs;
  final bookingId = "".obs;

  ProviderRatingController() {
    var arguments = Get.arguments as Map<String, dynamic>;
    // _bookingRepository = new BookingRepository();
    _eProviderRepository = new EProviderRepository();
    eProvider.value = arguments['eProvider'] as EProvider;
    bookingId.value = arguments['booking_id'];
    // eProvider.value = arguments['eProvider'] as EProvider;
  }

  @override
  void onInit() {
    // booking.value = Get.arguments as Booking;
    review.value.user = Get.find<AuthService>().user.value;
    // review.value.user = Get.find<AuthService>().user.value;
    // review.value.eService = booking.value.eService;
    super.onInit();
  }

  // Future getEProvider() async {
  //   try {
  //     eProvider.value = await _eProviderRepository.get(eProvider.value.id);
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // Future addReview() async {
  //   try {
  //     if (review.value.rate < 1) {
  //       Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
  //       return;
  //     }
  //     if (review.value.review == null || review.value.review.isEmpty) {
  //       Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
  //       return;
  //     }
  //     await _bookingRepository.addReview(review.value);
  //     Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
  //     Timer(Duration(seconds: 2), () {
  //       Get.find<RootController>().changePage(0);
  //     });
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future addProviderReview() async {
    try {
      if (review.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return;
      }
      if (review.value.review == null || review.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return;
      }
      await _eProviderRepository.addProviderReview(review.value, eProvider.value, bookingId.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
      Get.find<RootController>().changePage(0);
      // Timer(Duration(seconds: 1), () {
      //   Get.find<RootController>().changePage(0);
      // });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<bool> addTipsProviderReview() async {
    try {
      if (review.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return false;
      }
      if (review.value.review == null || review.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return false;
      }
      // await _eProviderRepository.addProviderReview(review.value, eProvider.value, bookingId.value);
      return true;
    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      return false;
    }
  }

  Future<bool> addTipsProviderReviewTest() async {
    try {
      if (review.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return false;
      }
      if (review.value.review == null || review.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return false;
      }
      await _eProviderRepository.addProviderReview(review.value, eProvider.value, bookingId.value);
      return true;
    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      return false;
    }
  }

}
