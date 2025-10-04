import 'package:get/get.dart';

import '../../../providers/database_helper.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../controllers/service__details_controller.dart';
import '../controllers/service_controller.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceController>(
      () => ServiceController(),
    );
    Get.lazyPut<ServiceDetailsController>(
          () => ServiceDetailsController(),
    );
    // Get.lazyPut<AddToCartController>(
    //       () => AddToCartController(),
    // );
    // Get.lazyPut<DatabaseHelper>(
    //       () => DatabaseHelper(),
    // );
    // Get.lazyPut(()=>DatabaseHelper())
  }
}
