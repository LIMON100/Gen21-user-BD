import 'dart:developer';
import 'dart:ffi';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/service_model.dart';
import '../../../models/sub_service_model.dart';
import '../../../repositories/service_repository.dart';

class SubServiceController extends GetxController {
  final subService = SubService().obs;
  final heroTag = ''.obs;
  final service_id = ''.obs;
  ServiceRepository _serviceRepository;

  SubServiceController() {
    _serviceRepository = new ServiceRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    print("KYToito argmnts EServiceController ${arguments.toString()}");
    service_id.value = arguments['service_id'] as String;
    heroTag.value = arguments['heroTag'] as String;
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

    getSubService(service_id.value);
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getSubService(String id) async {
    print("fsjfsads3");

    try {
      subService.value = await _serviceRepository.getSubService(id);
      print("fsjfsads78 ${subService.value.toString()}");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }


}
