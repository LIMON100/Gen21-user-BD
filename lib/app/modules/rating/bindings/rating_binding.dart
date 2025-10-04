import 'package:get/get.dart';

import '../controllers/provider_rating_controller.dart';
import '../controllers/rating_controller.dart';

class RatingBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<RatingController>(
    //   () => RatingController(),
    // );
    Get.lazyPut<ProviderRatingController>(
      () => ProviderRatingController(),
    );
  }
}
