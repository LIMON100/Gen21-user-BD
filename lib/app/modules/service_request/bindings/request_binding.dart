import 'package:get/get.dart';

import '../controllers/RequestController.dart';


class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestController>(
      () => RequestController(),
    );
  }
}
