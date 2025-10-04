import 'package:get/get.dart';
import '../controllers/e_way_controller.dart';

class EWayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EWayController>(
          () => EWayController(),
    );
  }
}
