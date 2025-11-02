import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../global_widgets/block_button_widget.dart';
// import '../controllers/booking_controller.dart';
import '../../new_payment_ui/ServicePayment.dart';
import '../../new_payment_ui/ServicePayment2.dart';
import '../controllers/booking_controller_new.dart';

import 'package:http/http.dart' as http;


class BookingActionsWidgetNew extends GetView<BookingControllerNew> {
  const BookingActionsWidgetNew({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _booking = controller.booking;
    return Obx(() {
      // print("jsnfjsansdkll ${controller.booking.value.payment?.paymentStatus?.status}");
      print("BOOKINGVALUE2");
      print(_booking.value.total_payable_amount);
      printWrapped("djsfjsafs _booking.value.booking_status_id: ${_booking.value.booking_status_id}");
      printWrapped("djsfjsafs _booking.value.toString(): ${_booking.value.toString()}");
      if (_booking.value.status == null) {
        return SizedBox(height: 0);
      }
      if (_booking.value.status.order == Get.find<GlobalService>().global.value.onTheWay) {
        return SizedBox(height: 0);
      } else {
        return Container(

          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max, children: [

            // if (_booking.value.status.order == Get.find<GlobalService>().global.value.done && _booking.value.payment == null)
            //   Expanded(
            //     child: BlockButtonWidget(
            //         text: Stack(
            //           alignment: AlignmentDirectional.centerEnd,
            //           children: [
            //             SizedBox(
            //               width: double.infinity,
            //               child: Text(
            //                 "Go to Checkout".tr,
            //                 textAlign: TextAlign.center,
            //                 style: Get.textTheme.headline6.merge(
            //                   TextStyle(color: Get.theme.primaryColor),
            //                 ),
            //               ),
            //             ),
            //             Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 22)
            //           ],
            //         ),
            //         color: Get.theme.colorScheme.secondary,
            //         onPressed: () {
            //           Get.toNamed(Routes.CHECKOUT, arguments: _booking.value);
            //         }),
            //   ),
            if (_booking.value.status.order == Get.find<GlobalService>().global.value.ready)
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    child: BlockButtonWidget(
                        text: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Start".tr,
                                textAlign: TextAlign.center,
                                style: Get.textTheme.headline6.merge(
                                  TextStyle(color: Get.theme.primaryColor),
                                ),
                              ),
                            ),
                            Icon(Icons.play_arrow, color: Get.theme.primaryColor, size: 24)
                          ],
                        ),
                        color: Get.theme.colorScheme.secondary,
                        onPressed: () {
                          controller.startBookingService();
                        }),
                  ),
              ),

            if (_booking.value.status.order == Get.find<GlobalService>().global.value.inProgress)
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: BlockButtonWidget(
                      text: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Finish".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor),
                              ),
                            ),
                          ),
                          Icon(Icons.stop, color: Get.theme.primaryColor, size: 24)
                        ],
                      ),
                      color: Get.theme.hintColor,
                      onPressed: () {
                        controller.finishBookingService();
                      }),
                ),
              ),
            if (_booking.value.booking_status_id != "7" && _booking.value.status.order >= Get.find<GlobalService>().global.value.done)
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: BlockButtonWidget(
                      text: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Leave a Review".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor),
                              ),
                            ),
                          ),
                          Icon(Icons.star_outlined, color: Get.theme.primaryColor, size: 22)
                        ],
                      ),
                      color: Get.theme.colorScheme.secondary,
                      onPressed: () {
                        // Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _eService.eProvider, 'heroTag': 'e_service_details'});
                        // print("djsnfjajkjkd ${_booking.value.eProvider.pivot.e_provider_id}");
                        // Get.toNamed(Routes.PROVIDER_RATING, arguments: {'eProvider': EProvider(id:_booking.value.eProvider.pivot.e_provider_id), 'booking_id': _booking.value.id});
                        Get.toNamed(Routes.PROVIDER_RATING, arguments: {'eProvider': EProvider(id:_booking.value.acceptor_provider_id), 'booking_id': _booking.value.id});

                        // Get.showSnackbar(Ui.SuccessSnackBar(message: "Coming soon...".tr));
                      }),
                ),
              ),
            // if (_booking.value.booking_status_id != "7" && controller.booking.value.payment?.paymentStatus?.status != "Paid")
            //   controller.initiatingEway.value
            //       ? Expanded(child: Container( width: 30, height: 30, child: Center(child: CircularProgressIndicator())))
            //       :
            //   Expanded(
            //           child: Container(
            //             margin: EdgeInsets.only(right: 5),
            //             child: BlockButtonWidget(
            //                 text: Stack(
            //                   alignment: AlignmentDirectional.centerEnd,
            //                   children: [
            //                     SizedBox(
            //                       width: double.infinity,
            //                       child: Text(
            //                         "Pay Now".tr,
            //                         textAlign: TextAlign.center,
            //                         style: Get.textTheme.headline6.merge(
            //                           TextStyle(color: Get.theme.primaryColor),
            //                         ),
            //                       ),
            //                     ),
            //                     Icon(Icons.attach_money_outlined, color: Get.theme.primaryColor, size: 22)
            //                   ],
            //                 ),
            //                 color: Get.theme.colorScheme.secondary,
            //                 onPressed: () {
            //                   if(_booking.value.total_payable_amount > 0) {
            //                     Navigator.pop(context);
            //                     Navigator.of(context).push(
            //                       MaterialPageRoute(
            //                         builder: (context) => ServicePayment(id: _booking.value.id, name: _booking.value.user.name, email: _booking.value.user.email,
            //                             address: _booking.value.address.address, mobile: _booking.value.user.phoneNumber, coupon: _booking.value.coupon.toString(),
            //                             amount: _booking.value.total_amount.toString(), paybleAmount: _booking.value.total_payable_amount.toString(),
            //                             serviceInfo: _booking.value.eService.name),
            //                       ),
            //                       // MaterialPageRoute(
            //                       //   builder: (context) => ServicePayment2(id: _booking.value.id),
            //                       // ),
            //                     );
            //                     // controller.initiateEway(_booking.value);
            //                   }else{
            //                     Get.showSnackbar(Ui.ErrorSnackBar(message: "Total payable amount can't be 0!".tr));
            //                   }
            //                 }),
            //           ),
            //         ),


            // SizedBox(width: 10),// Stop the cancel option
            // if (_booking.value.booking_status_id != "7" && _booking.value.status.order < Get.find<GlobalService>().global.value.onTheWay)
            // // if (_booking.value.booking_status_id != "7")
            //   Expanded(
            //     child: Container(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [
            //           MaterialButton(
            //             onPressed: () {
            //               // Navigator.pop(context);
            //               // Navigator.of(context).push(
            //               //   MaterialPageRoute(
            //               //     builder: (context) => ServicePayment(),
            //               //   ),
            //               // );
            //               controller.cancelBookingServiceNew(); //Cancel Button
            //             },
            //             padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //             color: Get.theme.hintColor.withOpacity(0.1),
            //             child: Text("Cancel".tr, style: Get.textTheme.bodyText2),
            //             elevation: 0,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
          ]).paddingSymmetric(vertical: 10, horizontal: 20),
        );
      }
    });
  }
}
