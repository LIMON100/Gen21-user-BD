import 'package:get/get.dart';

import '../../bookings/controllers/booking_controller_new.dart';
import '../../bookings/controllers/bookings_controllerNew.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../orders/orders_controller/orders_controller.dart';
import '../../account/controllers/account_controller.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.lazyPut<AddToCartController>(
      () => AddToCartController(),
    );
    Get.put(HomeController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    Get.put(BookingsController(), permanent: true);
    //
    // Get.lazyPut<BookingsController>(
    //       () => BookingsController(),
    // );
    //
    // Get.put(BookingsControllerNew(), permanent: true);

    // Get.lazyPut<BookingController>(
    //   () => BookingController(),
    // );
    Get.lazyPut<BookingControllerNew>(
      () => BookingControllerNew(),
    );
    Get.lazyPut<BookingsControllerNew>(
      () => BookingsControllerNew(),
    );
    Get.put<MessagesController>(
      MessagesController(), permanent: true
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
