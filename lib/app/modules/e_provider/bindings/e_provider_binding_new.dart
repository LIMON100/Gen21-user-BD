import 'package:get/get.dart';

import '../../messages/controllers/messages_controller.dart';
import '../controllers/e_provider_controller.dart';
import '../controllers/e_provider_controller_new.dart';
import '../controllers/e_services_controller.dart';

class EProviderBindingNew extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EProviderControllerNew>(
      () => EProviderControllerNew(),
    );
    // Get.lazyPut<EServicesController>(
    //   () => EServicesController(),
    // );
    // Get.lazyPut<MessagesController>(
    //   () => MessagesController(),
    // );
  }
}
