// import 'dart:developer';
// import 'dart:ffi';
// import 'package:get/get.dart';
// import '../../../../common/log_data.dart';
// import '../../../../common/ui.dart';
// import '../../../models/coupon_model.dart';
// import '../../../models/search_suggestion_model.dart';
// import '../../../models/service_details_model.dart';
// import '../../../models/service_model.dart';
// import '../../../providers/laravel_provider.dart';
// import '../../../repositories/service_repository.dart';
//
// class ServiceController extends GetxController {
//   final service = GService().obs;
//   final currentSlide = 0.obs;
//   final heroTag = ''.obs;
//   ServiceRepository _serviceRepository;
//   // List<String> tabs = ["Services", "Description", "Faq"];
//   List<String> tabs = ["Services", "", ""];
//   final selectedTab = 0.obs;
//   String categoryId;
//
//   final serviceDetails = ServiceDetails().obs;
//
//   var couponss = Coupon().obs;
//   List<Coupon> newCouponList = [];
//
//
//   ServiceController() {
//     print("sjdnfhsba ServiceController() ${selectedTab.value}");
//     _serviceRepository = new ServiceRepository();
//   }
//
//   @override
//   void onInit() async {
//     print("sjdnfhsba onInit() ${selectedTab.value}");
//
//     var arguments = Get.arguments as Map<String, dynamic>;
//     print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
//     heroTag.value = arguments['heroTag'] as String;
//     // _searchSuggestion = arguments['searchSuggestion'] as SearchSuggestion;
//     categoryId = arguments['category_id'];
//     print("KYToitojuu categoryId ServiceController ${categoryId}");
//     super.onInit();
//   }
//
//   @override
//   void onReady() async {
//     print("fsjfsads0");
//     // await tryCoupon();
//     await refreshEService();
//     super.onReady();
//   }
//
//   Future refreshEService({bool showMessage = false}) async {
//     print("fsjfsads1");
//     getService(categoryId);
//     if (showMessage) {
//       // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
//     }
//   }
//
//   //coupon
//   Future<void> tryCoupon() async {
//     print("COUPONCALLING");
//     newCouponList = await _serviceRepository.tryCoupon();
//     print(newCouponList);
//   }
//
//
//   Future getService(String id) async {
//     print("fsjfsads3");
//
//     try {
//       service.value = await _serviceRepository.get(id);
//       printWrapped("sdnkjfnajk response data: ${service.value.toString()}");
//     } catch (e) {
//       // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//       Get.showSnackbar(Ui.ErrorSnackBar(message: "Data not found"));
//     }
//   }
//
//   // Future getServiceDetails(String id) async {
//   //   print("fsjfsads3");
//   //
//   //   try {
//   //     serviceDetails.value = await _serviceRepository.getServiceDetails(id);
//   //     print("sdhbfhbash ${serviceDetails.value.toString()}");
//   //   } catch (e) {
//   //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//   //   }
//   // }
//
//   void changeTab(int id) async {
//     selectedTab.value = id;
//   }
//
// }



import 'dart:developer';
import 'dart:ffi';
import 'package:get/get.dart';
import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/coupon_model.dart';
import '../../../models/search_suggestion_model.dart';
import '../../../models/service_details_model.dart';
import '../../../models/service_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../repositories/service_repository.dart';

class ServiceController extends GetxController {
  final service = GService().obs;
  final currentSlide = 0.obs;
  final heroTag = ''.obs;
  ServiceRepository _serviceRepository;

  // REMOVED: Unused properties for tabs
  // List<String> tabs = ["Services", "Description", "Faq"];
  // List<String> tabs = ["Services", "", ""];
  // final selectedTab = 0.obs;
  String categoryId;

  final serviceDetails = ServiceDetails().obs;

  var couponss = Coupon().obs;
  List<Coupon> newCouponList = [];


  ServiceController() {
    // MODIFIED: Removed reference to selectedTab
    print("sjdnfhsba ServiceController()");
    _serviceRepository = new ServiceRepository();
  }

  @override
  void onInit() async {
    // MODIFIED: Removed reference to selectedTab
    print("sjdnfhsba onInit()");

    var arguments = Get.arguments as Map<String, dynamic>;
    print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
    heroTag.value = arguments['heroTag'] as String;
    // _searchSuggestion = arguments['searchSuggestion'] as SearchSuggestion;
    categoryId = arguments['category_id'];
    print("KYToitojuu categoryId ServiceController ${categoryId}");
    super.onInit();
  }

  @override
  void onReady() async {
    print("fsjfsads0");
    // await tryCoupon();
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    print("fsjfsads1");
    getService(categoryId);
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  //coupon
  Future<void> tryCoupon() async {
    print("COUPONCALLING");
    newCouponList = await _serviceRepository.tryCoupon();
    print(newCouponList);
  }


  Future getService(String id) async {
    print("fsjfsads3");

    try {
      service.value = await _serviceRepository.get(id);
      printWrapped("sdnkjfnajk response data: ${service.value.toString()}");
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Data not found"));
    }
  }

// REMOVED: Unused method for changing tabs
// void changeTab(int id) async {
//   selectedTab.value = id;
// }

}