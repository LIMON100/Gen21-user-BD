import 'package:get/get.dart';
import '../controller/sub_service_controller.dart';

class SubServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubServiceController>(
      () => SubServiceController(),
    );
  }
}
