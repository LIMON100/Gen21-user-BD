import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/log_data.dart';
import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/orders_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/global_service.dart';

class BookingsControllerNew extends GetxController {
  BookingRepository _bookingsRepository;
  final bookings = <BookingNew>[].obs;
  final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  // final currentStatus = '0'.obs;
  String orderId = "";
  var hasPending = false.obs;

  final booking = BookingNew().obs;

  ScrollController scrollController;

  GoogleMapController mapController;
  final allMarkers = <Marker>[].obs;

  final tabs = <String>[];
  final currentTab = 0.obs;


  BookingsControllerNew() {
    _bookingsRepository = new BookingRepository();
  }

  @override
  Future<void> onInit() async {
    tabs.add("Received");
    tabs.add("Not Received");
    await getBookingStatuses();
    print("hsbjkakjsj order.value ${Get.arguments.toString()}");
    // currentStatus.value = getStatusByOrder(1).id;
    orderId = Get.arguments['orderId'] as String;
    hasPending.value = Get.arguments['hasPending'] as bool;
    print("hsbjkakjsj orderId: $orderId hasPending: $hasPending");
    refreshBookings();
    super.onInit();
  }

  Future refreshBookings({bool showMessage = false}) async {
    print("hsbjkakjsj refreshBookings() called ${orderId} ");

    changeTab(currentTab.value);
    if (showMessage) {
      await getBookingStatuses();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Bookings page refreshed successfully".tr));
    }
  }



  void changeTab(int selectedTab) async {
    print("jfkamsfdsfds changeTab() called ${selectedTab} ");
    this.bookings.clear();
    // currentStatus.value = statusId ?? currentStatus.value;
    currentTab.value = selectedTab;
    page.value = 0;
    await loadBookingsOfStatus(selectedTab: selectedTab);
  }

  Future getBookingStatuses() async {
    print("hsbjkakjsj getBookingStatuses() called ${orderId} ");
    try {
      bookingStatuses.assignAll(await _bookingsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) => bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        // Get.showSnackbar(Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  Future loadBookingsOfStatus({int selectedTab}) async {
    print("736635 loadBookingsOfStatus() orderId: ${orderId} ");
    try {
      isLoading.value = true;

      List<BookingNew> _bookings = [];
      if (bookingStatuses.isNotEmpty) {
        if(selectedTab == 0) {
          print("736635 loadBookingsOfStatus() tab 1");
          _bookings = await _bookingsRepository.allNew(orderId: orderId);
        }else {

          print("736635 loadBookingsOfStatus() tab 2");

          _bookings = await _bookingsRepository.getPendingBookings(orderId: orderId);
        }
      }
      bookings.value = _bookings;
      printWrapped("736635 _bookings ${_bookings.toString()}");

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBookingService(Booking booking) async {
    try {
      if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new Booking(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initBookingAddress() {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: booking.value.address.getLatLng(), zoom: 12.4746),
      ),
    );
    MapsUtil.getMarker(address: booking.value.address, id: booking.value.id, description: booking.value.user?.name ?? '').then((marker) {
      allMarkers.add(marker);
    });
  }

  OrderStatusWithColor getBookingStatusById(String statusId) {
    // todo have to make this status check dynamic
     print("jsdnkja statusId: $statusId");
    print("jsdnkja et.find<GlobalService>().global.value ${Get.find<GlobalService>().global.value.received}");
    if (statusId == "1") {
      return OrderStatusWithColor("Received", "#cccccc", "#000000");

    } else if (statusId == '4') {
      return OrderStatusWithColor("Accepted",  "#cccccc", "#000000");;
    } else if (statusId == "3") {
      return OrderStatusWithColor("On The Way",  "#cccccc", "#000000");
    } else if (statusId == "2") {
      return OrderStatusWithColor("In Progress", "#cccccc", "#000000");

    } else if (statusId == "5") {
      return OrderStatusWithColor("Ready", "#cccccc", "#000000");

    } else if (statusId == "6") {
      return OrderStatusWithColor("Done", "#00FF00", "#ffffff");
    } else if (statusId == "7") {
      return OrderStatusWithColor("Canceled", "#ff0000", "#ffffff");
    }else{
      return OrderStatusWithColor("Undefined", "#ffff00", "#cccccc");

    }
  }

}

class OrderStatusWithColor{
String status;
String backgroundColor;
String textColor;

OrderStatusWithColor(this.status, this.backgroundColor, this.textColor);
}

