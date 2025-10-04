/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/custom_page_model.dart';
import '../../../repositories/cart_repository.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../orders/orders_controller/orders_controller.dart';
import '../../orders/views/orders_view.dart';
import '../../account/views/account_view.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  // final cartsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  // CartRepository _cartRepository;
  CustomPageRepository _customPageRepository;

  // final AddToCartController _addToCartController = Get.put(AddToCartController());

  RootController() {
    _notificationRepository = new NotificationRepository();
    // _cartRepository = new CartRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await getCustomPages();
  }

  List<Widget> pages = [
    Home2View(),
    // BookingsView(),
    OrdersView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  Future<void> changePageInRoot(int _index) async {
    print("wuhudsafa: changePageInRoot");
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      print("wuhudsafa: in 1");
      await Get.toNamed(Routes.LOGIN);
    } else {
      print("wuhudsafa: in 2");
      currentIndex.value = _index;
      await refreshPage(_index);
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    print("wuhudsafa: changePageOutRoot");
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      print("wuhudsafa: in 3");
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    await refreshPage(_index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      print("wuhudsafa: in 4");
      if (route.settings.name == Routes.ROOT) {
        print("wuhudsafa: in 5");
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          // await Get.find<BookingsController>().refreshBookings();
          // await Get.find<OrdersController>().refreshBookings();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  // void getCartsCount() async {
  //   var carts = await _cartRepository.getCartList();
  //   print("fjnjkankj ${carts.length}");
  //   cartsCount.value = carts.length;
  //
  // }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
