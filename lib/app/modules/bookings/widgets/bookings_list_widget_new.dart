import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/log_data.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/bookings_controller.dart';
import '../controllers/bookings_controllerNew.dart';
import 'bookings_list_item_widget.dart';
import 'bookings_list_item_widget_new.dart';

class BookingsListWidgetNew extends GetView<BookingsControllerNew> {
  BookingsListWidgetNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      printWrapped("sjfnajkj ${controller.bookings.toString()}");
      if (controller.bookings.isEmpty && controller.isLoading.value == true) {
        return CircularLoadingWidget(height: 300);
      } else {
        var padding = MediaQuery.of(context).padding;
        if (controller.bookings.isEmpty && controller.isLoading.value == false) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 120 - padding.top - padding.bottom,
            child: Center(
              child: Text(
                "No Data Found".tr,
                maxLines: 1,
                style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
              ),
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            primary: false,
            shrinkWrap: true,
            //fahmid don't know why +1 is here in below syntaxt
            itemCount: controller.bookings.length + 1,
            itemBuilder: ((_, index) {
              if (index == controller.bookings.length) {
                return Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: controller.isLoading.value ? 1 : 0,
                        child: new CircularProgressIndicator(),
                      ),
                    ),
                  );
                });
              } else {
                var _booking = controller.bookings.elementAt(index);
                printWrapped("fsjfsddjdads9671 booking: ${_booking.toString()}");
                printWrapped("fsjfsddjdads9671 serviceName: ${_booking.eService.images}");
                printWrapped("fsjfsddjdads9671 orderamount: ${_booking.total_payable_amount}");
                return BookingsListItemWidgetNew(booking: _booking, selectedTabPosition: controller.currentTab.value,);
                // return Container();
              }
            }),
          );
        }
      }
    });
  }
}
