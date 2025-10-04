/*
 * Copyright (c) 2020 .
 */

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/order_request_channel.dart';
import '../../../models/order_request_response_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../bookings/views/booking_details_view.dart';
import '../../home/views/home2_view.dart';
import '../../new_payment_ui/ServicePayment2.dart';
import '../../notifications/views/notifications_view.dart';
import '../../notifications/widgets/booking_notification_item_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/RequestController.dart' as rq;
import '../controllers/ServiceRequestController.dart';
import '../../bookings/controllers/booking_controller_new.dart' as bookController;
import '../../../models/notification_model.dart' as model;

class ServiceRequestListItemWidget extends GetView<ServiceRequestController> {
  ServiceRequestListItemWidget({Key key, @required int index})
      : _index = index,
        super(key: key);
  final int _index;

  // FOR TIPS
  String selectedOption = 'No';
  TextEditingController tipController = TextEditingController();
  double tipAmount = 0.0;
  double totalPrice = 0.0;
  bool tipsEnabled = false;
  double tipsAmount = 0.0;


  int bookID = 0;
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();


  Timer _timer;
  int remainingSeconds = 0;
  final time2 = '00.00'.obs;
  final time = ValueNotifier<String>('');

  Future startTimer() {
    int seconds = 180;
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;

    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainingSeconds ~/ 60;
        int seconds = remainingSeconds % 60;

        time.value = "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingSeconds--;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // fetchNotifications();

    Color _color = Get.theme.colorScheme.secondary;
    Service _service = controller.orderRequestResponse.value.eventData.service[_index];
    double payableAmount = int.parse(_service.addedUnit) * (double.parse(_service.price));
    print("sdjnfkjsan payable amount before discount $payableAmount");
    if (controller.orderRequestResponse.value.eventData.coupon_data != null) {
      if (controller.orderRequestResponse.value.eventData.coupon_data.discountType.toString() == "percent") {
        controller.orderRequestResponse.value.eventData.coupon_data.discountType.toString();
        payableAmount = payableAmount - payableAmount * (controller.orderRequestResponse.value.eventData.coupon_data.discount / 100);
      }
      else {
        payableAmount = payableAmount - controller.orderRequestResponse.value.eventData.coupon_data.discount;
      }
    }

    print("sdjnfkjsan payable amount after discount $payableAmount");
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.BOOKING, arguments: _service);
      },
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Obx((){
          var response = controller.orderRequestResponse.value.eventData.service[_index];
          print("sdnjkfnkjdaj_ser2333: $response}");
          var _service = controller.orderRequestResponse.value.eventData.service[_index];
          print("sdnjkfnkjdaj ser: $_service}");

          controller.fetchNotifications();
          // controller.startTimer2(20);
          // print("NOTFIYVAL");
          // print(nt.data);

          return  Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: _service.imageUrl,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Column(
                      children: [
                        Text(
                            _service.bookingAt != null? DateFormat('HH:mm', Get.locale.toString()).format(_service.bookingAt): "N/A",
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                              TextStyle(color: Get.theme.primaryColor, height: 1.4),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        Text( _service.bookingAt != null? DateFormat('dd', Get.locale.toString()).format(_service.bookingAt): "N/A",
                            maxLines: 1,
                            style: Get.textTheme.headline3.merge(
                              TextStyle(color: Get.theme.primaryColor, height: 1),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        Text(_service.bookingAt != null? DateFormat('MMM', Get.locale.toString()).format(_service.bookingAt): "N/A",
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                              TextStyle(color: Get.theme.primaryColor, height: 1),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                      ],
                    ),
                    decoration: BoxDecoration(

                      color: _color,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${_service.serviceName}", style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 5,
                  ),
                  if(_service.name != null)
                  Text("${_service.name}", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   children: [
                  //     Text("Price:",
                  //         style: TextStyle(
                  //           color: Get.theme.colorScheme.secondary,
                  //           fontSize: 14,
                  //         )),
                  //     SizedBox(width: 10),
                  //     Text("${_service.addedUnit} * ${_service.price} = \$${int.parse(_service.addedUnit) * (double.parse(_service.price))}", style: TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 14)),
                  //   ],
                  // ),

                  Row(
                    children: [
                      Text("Price:",
                          style: TextStyle(
                            color: Get.theme.colorScheme.secondary,
                            fontSize: 14,
                          )
                      ),
                      SizedBox(width: 5),
                      if (controller.orderRequestResponse.value.eventData.coupon_data != null) Text("\$${int.parse(_service.addedUnit) * (double.parse(_service.price))}", style: TextStyle(color: Colors.grey, fontSize: 14, decoration: TextDecoration.lineThrough), maxLines: 4, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl, textAlign: TextAlign.justify),
                      SizedBox(width: 5),
                      Text("\$$payableAmount", style: TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 14), maxLines: 4, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl, textAlign: TextAlign.justify),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.place_outlined,
                  //       size: 18,
                  //       color: Get.theme.focusColor,
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //
                  //     ),
                  //     Text(
                  //       "${_orderRequestResponse.eventData.address.address}",
                  //       style: TextStyle(color: Get.theme.focusColor, fontSize: 14),
                  //     ),
                  //     Text(
                  //       "${_service.}",
                  //       style: TextStyle(color: Get.theme.focusColor, fontSize: 14),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text("Order status:  "),
                  //     // Obx(() {
                  //     //   return _service.status == null ? Text("Pending") : Text("Accepted");
                  //     // })
                  //     _service.status == null ? Text("Pending") : Text("Received")
                  //   ],
                  // )
                  // Making Received a button
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text("Order status: "),
                  //     _service.status == null
                  //         ? Text("Pending")
                  //         : TextButton(
                  //       onPressed: () {
                  //         // Get.toNamed(Routes.BOOKING_DETAILS);
                  //         Get.toNamed(Routes.NOTIFICATIONS);
                  //         // Get.toNamed(Routes.BOOKING_DETAILS, arguments: BookingNew());
                  //         // Get.toNamed(Routes.BOOKING_DETAILS, arguments: BookingNotificationItemWidget(notification: notification.data['booking_id']));
                  //       },
                  //       child: Text("Received"),
                  //     ),
                  //   ],
                  // ),

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text("Order status: "),
                  //     SizedBox(height: 8), // Add some space between the text and the button
                  //     _service.status == null
                  //         ? Text("Pending")
                  //         : Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             Navigator.pop(context);
                  //             Navigator.of(context).push(
                  //               MaterialPageRoute(
                  //                   builder: (context) => ServicePayment2(id: controller.bookID.toString())),
                  //             );
                  //           },
                  //           child: Text("Pay Now"),
                  //         ),
                  //         SizedBox(height: 8),
                  //         startTimer(),
                  //         SingleChildScrollView(
                  //           child: Text(
                  //             " Please pay in 3 mintues\n otherwise the request\n will be Cancel",
                  //             style: TextStyle(fontSize: 12, color: Colors.black),
                  //           ),
                  //         ),
                  //         SizedBox(height: 4),
                  //         // Text(
                  //         //   controller.time.value,
                  //         //   style: Get.textTheme.subtitle2,
                  //         // ),
                  //         // SingleChildScrollView(
                  //         //   child: Text(
                  //         //     " Your request is ACCEPTED.\n Please go to the NOTIFICATION\n section OR press the 'RECEIVED'\n button to go to NOTIFICATION\n and PAY for your service.",
                  //         //     style: TextStyle(fontSize: 12, color: Colors.black),
                  //         //   ),
                  //         // ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order status: "),
                      SizedBox(height: 8), // Add some space between the text and the button
                      _service.status == null
                          ? Text("Pending")
                          : FutureBuilder<void>(
                        future: startTimer(), // Start the timer asynchronously
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState == ConnectionState.waiting) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            // Show the UI once the future completes
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => ServicePayment2(id: controller.bookID.toString())),
                                    );
                                  },
                                  child: Text("Pay Now"),
                                ),
                                SizedBox(height: 8),
                                SingleChildScrollView(
                                  child: Text(
                                    " Please pay in 3 mintues\n otherwise the request\n will be Cancel",
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 5,),
                  // Container(
                  //   margin: EdgeInsets.only(left: 30, right: 30),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GestureDetector(
                  //           onTap: () {
                  //             // AcceptRequestBody acceptRequestBody = new AcceptRequestBody(e_service: "${_service.eServiceId}", event_id: "${_service.eventId}", booking_status_id: "4", quantity: "${_service.addedUnit}", coupon_id: "1", order_id: "${_orderRequestPush.data.orderId}", address_id: "1");
                  //             // _requestController.acceptBookingRequest(body: acceptRequestBody);
                  //             // contr
                  //             // _requestController.declineBookingRequest(_service.eServiceId, _service.serviceType);
                  //           },
                  //           child: Text("Cancel", style: TextStyle(color: Get.theme.focusColor),)),
                  //       GestureDetector(
                  //           onTap: () {
                  //             // AcceptRequestBody acceptRequestBody = new AcceptRequestBody(e_service: "${_service.eServiceId}", event_id: "${_service.eventId}", booking_status_id: "4", quantity: "${_service.addedUnit}", coupon_id: "1", order_id: "${_orderRequestPush.data.orderId}", address_id: "1");
                  //             // _requestController.acceptBookingRequest(_service.eServiceId, _service.serviceType , body: acceptRequestBody);
                  //           },
                  //           child: Text("Accept")),
                  //     ],
                  //   ),
                  // )

                  if(_service.status == null)
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() {
                            return controller.isLoading.value
                                ? Container(
                              margin: EdgeInsets.only(right: 20, bottom: 10),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : GestureDetector(
                              onTap: () async {
                                controller.cancelOrder("${controller.orderRequestResponse.value.eventData.orderId}");
                                // Home2View();
                                Get.find<RootController>().changePage(0);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 20, bottom: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red), // Add border here
                                  borderRadius: BorderRadius.circular(8.0), // Optional: add border radius for rounded corners
                                ),
                                child: Text(
                                  "Stop Request",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    // ValueListenableBuilder(
                    //   valueListenable: time,
                    //   builder: (context, value, child) {
                    //     return Text(time.value);
                    //   },
                    // ),
                    ValueListenableBuilder(
                        valueListenable: time,
                        builder: (context, value, child){
                          if (time.value == "00:00" || time.value == "00:01")
                            return FutureBuilder<void>(
                              future: controller.cancelOrder("${controller.orderRequestResponse.value.eventData.orderId}"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  Get.find<RootController>().changePage(0);
                                  return Text("Order Cancelled.",style: TextStyle(color: Colors.red),);
                                }
                                else {
                                  if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  else {
                                    return Text("Order Cancelled.");
                                  }
                                }
                              },
                            );
                          else if(time.value != "00:00")
                            return Text(time.value);
                          else
                            return Text("");
                        }
                    )
                ],
              ),
            ],
          );
        },
        ),
      ),
    );
  }
}
