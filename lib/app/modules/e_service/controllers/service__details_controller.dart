// import 'dart:developer';
// import 'dart:ffi';
// import 'package:get/get.dart';
// import '../../../../common/ui.dart';
// import '../../../models/e_service_model.dart';
// import '../../../models/search_suggestion_model.dart';
// import '../../../models/service_details_model.dart';
// import '../../../models/service_model.dart';
// import '../../../repositories/service_repository.dart';
//
// class ServiceDetailsController extends GetxController {
//   // final service = GService().obs;
//   final eService = EService().obs;
//   final currentSlide = 0.obs;
//   final heroTag = ''.obs;
//   ServiceRepository _serviceRepository;
//   List<String> tabs = ["Services", "Description", "Faq"];
//   final selectedTab = 0.obs;
//   String categoryId;
//
//   final serviceDetails = ServiceDetails().obs;
//
//
//   ServiceDetailsController() {
//     _serviceRepository = new ServiceRepository();
//   }
//
//   @override
//   void onInit() async {
//     var arguments = Get.arguments as Map<String, dynamic>;
//     print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
//     // heroTag.value = arguments['heroTag'] as String;
//     eService.value = arguments['eService'] as EService;
//     super.onInit();
//   }
//
//   @override
//   void onReady() async {
//     print("fsjfsads0");
//     await refreshEService();
//     super.onReady();
//   }
//
//   Future refreshEService({bool showMessage = false}) async {
//     print("fsjfsads1");
//
//     // getService("1");
//
//     getServiceDetails(eService.value.id);
//     if (showMessage) {
//       // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
//     }
//   }
//
//
//   Future getServiceDetails(String id) async {
//     print("fsjfsads3  serviceId: ${id}");
//
//     // try {
//       serviceDetails.value = await _serviceRepository.getServiceDetails(id);
//       print("sdhbfhbash ${serviceDetails.value.toString()}");
//     // } catch (e) {
//     //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//     // }
//   }
//
//   void changeTab(int id) async {
//     selectedTab.value = id;
//   }
//
// }



import 'dart:developer';
import 'dart:ffi';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/search_suggestion_model.dart';
import '../../../models/service_details_model.dart';
import '../../../models/service_model.dart';
import '../../../repositories/service_repository.dart';

class ServiceDetailsController extends GetxController {
  final eService = EService().obs;
  final currentSlide = 0.obs;
  final heroTag = ''.obs;
  ServiceRepository _serviceRepository;

  // REMOVED: Unused properties and methods for handling tabs
  // List<String> tabs = ["Services", "Description", "Faq"];
  // final selectedTab = 0.obs;
  // String categoryId;

  final serviceDetails = ServiceDetails().obs;


  ServiceDetailsController() {
    _serviceRepository = new ServiceRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
    eService.value = arguments['eService'] as EService;
    super.onInit();
  }

  @override
  void onReady() async {
    print("fsjfsads0");
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    print("fsjfsads1");
    getServiceDetails(eService.value.id);
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }


  Future getServiceDetails(String id) async {
    print("fsjfsads3  serviceId: ${id}");

    try {
      serviceDetails.value = await _serviceRepository.getServiceDetails(id);
      print("sdhbfhbash ${serviceDetails.value.toString()}");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

// REMOVED: This method is no longer needed as there are no tabs to change.
// void changeTab(int id) async {
//   selectedTab.value = id;
// }
}