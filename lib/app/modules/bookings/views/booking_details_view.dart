import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_services/app/modules/service_request/controllers/RequestController.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/log_data.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/order_request_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/global_service.dart';
import '../../tips/hintController.dart';
import '../../tips/tip_controller.dart';
import '../controllers/booking_controller_new.dart';
import '../widgets/booking_actions_widget.dart';
import '../widgets/booking_actions_widget_new.dart';
import '../widgets/booking_row_widget.dart';
import '../widgets/booking_til_widget.dart';
import '../widgets/booking_title_bar_widget.dart';

import 'package:home_services/app/modules/service_request/controllers/ServiceRequestController.dart';
import 'package:countdown/countdown.dart';


class BookingDetailsView extends GetView<BookingControllerNew> {

  // RequestController _requestController;
  RequestController _requestController2 = Get.find<RequestController>();
  final ValueNotifier<String> selectedOption = ValueNotifier<String>('NO');
  final ValueNotifier<String> tipText = ValueNotifier<String>('');
  Completer<void> _dialogCompleter = Completer<void>();

  final TipController tipController = Get.put(TipController());
  final TextEditingController textFieldController = TextEditingController();

  // test review
  bool test_review = false;

  BookingDetailsView() {
    textFieldController.text = tipController.tipText.value;
  }

  Future<void> _showTipDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Tip Amount:'),
          content: TextField(
            controller: textFieldController,
            keyboardType: TextInputType.number,
            onChanged: (String text) {
              tipController.setTipText(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter tip amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _dialogCompleter.complete(); // Complete the Future when the dialog is closed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the tip amount and close the dialog
                selectedOption.value = 'YES';
                Navigator.of(context).pop();
                _dialogCompleter.complete(); // Complete the Future when the dialog is closed
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      // Reset the dialogCompleter for future use
      _dialogCompleter = Completer<void>();
    });
  }


  @override
  Widget build(BuildContext context) {
    // _requestController = Get.put(RequestController());
    // String enteredText = _requestController.noteEditingController.text;
    // String enteredText = Get.find<RequestController>().noteEditingController.text;
    return Scaffold(
      bottomNavigationBar: Obx(() {
        // print("sdjnjfnaj ${controller.booking.value.is_reviewd}");
        return controller.isLoading.value? Center(child:  SizedBox(width: 28, height: 28, child: CircularProgressIndicator()),): controller.booking.value.is_reviewd != null && controller.booking.value.is_reviewd == true
            ? Container(
                color: Colors.green,
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                child: Text(
                  "This service has been completed",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : BookingActionsWidgetNew();
      }),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshBooking(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                // expandedHeight: 370,
                expandedHeight: 370,
                elevation: 0,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => {Get.back()},
                ),
                bottom: PreferredSize(
                    preferredSize: new Size(Get.height, 150),
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      // height: 135,
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                      ),
                      child: buildBookingTitleBarWidget(controller.booking),
                    )),
                // buildBookingTitleBarWidgetOld(controller.booking),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return GoogleMap(
                      compassEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      // liteModeEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
                      markers: Set.from(controller.allMarkers),
                      onMapCreated: (GoogleMapController _con) {
                        controller.mapController = _con;
                      },
                    );
                  }),
                ).marginOnly(bottom: 68),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      if (controller.booking.value.eProvider != null && controller.booking.value.eProvider.phoneNumber != "")
                        return buildContactProvider(controller.booking.value);
                      else
                        return SizedBox();
                    }),
                    Obx(() {
                      if (controller.booking.value.status == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Booking Details".tr, style: Get.textTheme.subtitle2),
                          actions: [Text("#" + controller.booking.value.id, style: Get.textTheme.subtitle2)],
                          content: Column(
                            children: [
                              BookingRowWidget(
                                  descriptionFlex: 1,
                                  valueFlex: 2,
                                  description: "Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.booking.value.status.status,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              // BookingRowWidget(
                              //     description: "Payment Status".tr,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         Container(
                              //           padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.all(Radius.circular(5)),
                              //             color: Get.theme.focusColor.withOpacity(0.1),
                              //           ),
                              //           child: Text(
                              //             controller.booking.value.payment?.paymentStatus?.status ?? "Not Paid".tr,
                              //             style: TextStyle(color: Get.theme.hintColor),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     hasDivider: true
                              // ),
                              if (controller.booking.value.payment?.paymentMethod != null)
                                BookingRowWidget(
                                    description: "Payment Method".tr,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Get.theme.focusColor.withOpacity(0.1),
                                          ),
                                          child: Text(
                                            controller.booking.value.payment?.paymentMethod?.getName(),
                                            style: TextStyle(color: Get.theme.hintColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    hasDivider: true),
                              // BookingRowWidget(
                              //   description: "Hint".tr,
                              //   child: Ui.removeHtml(controller.booking.value.hint, alignment: Alignment.centerRight),
                              // ),
                              BookingRowWidget(
                                description: "Hint".tr,
                                child: Text(_requestController2.noteEditingController.text),
                              ),
                            ],
                          ),
                        );
                    }),
                    Obx(() {
                      if (controller.booking.value.duration == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Booking Date & Time".tr, style: Get.textTheme.subtitle2),
                          actions: [
                            Container(
                              padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Get.theme.focusColor.withOpacity(0.1),
                              ),
                              child: Obx(() {
                                return Text(
                                  controller.getTime(),
                                  style: Get.textTheme.bodyText2,
                                );
                              }),
                            )
                          ],
                          content: Obx(() {
                            return Column(
                              children: [
                                if (controller.booking.value.bookingAt != null)
                                  BookingRowWidget(
                                      description: "Booking At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.booking.value.bookingAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: controller.booking.value.startAt != null || controller.booking.value.endsAt != null),
                                if (controller.booking.value.startAt != null)
                                  BookingRowWidget(
                                      description: "Started At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.booking.value.startAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: false),
                                if (controller.booking.value.endsAt != null)
                                  BookingRowWidget(
                                    description: "Ended At".tr,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.booking.value.endsAt),
                                          style: Get.textTheme.caption,
                                          textAlign: TextAlign.end,
                                        )),
                                  ),
                                // if (controller.booking.value.status.status == 'On the Way')
                                //   BookingRowWidget(
                                //     description: "Expected Arrival Time".tr,
                                //     child: Align(
                                //       alignment: Alignment.centerRight,
                                //       child: Text(
                                //         controller.time.value,
                                //         style: Get.textTheme.subtitle2,
                                //       ),
                                //     ),
                                //     hasDivider: controller.booking.value.startAt != null || controller.booking.value.endsAt != null,
                                //   ),
                              ],
                            );
                          }),
                        );
                      }
                    ),

                    Obx(() {
                      if (controller.booking.value.eService == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Pricing".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              if (controller.booking.value.total_amount > controller.booking.value.total_payable_amount)
                                Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Total".tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: Get.textTheme.bodyText1,
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: Align(
                                      //     alignment: AlignmentDirectional.centerEnd,
                                      //     child: Ui.getPrice(
                                      //       _booking.getTotal(),
                                      //       style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                                      //     ),
                                      //   ),
                                      // ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // if (controller.booking.value.total_amount > controller.booking.value.total_payable_amount)
                                              //   Align(
                                              //     alignment: AlignmentDirectional.centerEnd,
                                              //     child: Ui.getPrice(
                                              //       controller.booking.value.total_amount,
                                              //       style: Get.textTheme.headline6.merge(TextStyle(
                                              //         color: Colors.grey,
                                              //         decoration: TextDecoration.lineThrough,
                                              //       )),
                                              //     ),
                                              //   ),
                                              // SizedBox(
                                              //   width: 5,
                                              // ),
                                              Align(
                                                alignment: AlignmentDirectional.centerEnd,
                                                child: Ui.getPrice(controller.booking.value.total_amount, style: Get.textTheme.subtitle2.copyWith(color: Colors.grey)),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              if (controller.booking.value.total_amount > controller.booking.value.total_payable_amount)
                                Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Discount".tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: Get.textTheme.bodyText1,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional.centerEnd,
                                                child: Ui.getPrice(controller.booking.value.total_amount - controller.booking.value.total_payable_amount, style: Get.textTheme.subtitle2.copyWith(color: Colors.grey)),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Payable Total".tr,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Get.textTheme.bodyText1,
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Align(
                                  //     alignment: AlignmentDirectional.centerEnd,
                                  //     child: Ui.getPrice(
                                  //       _booking.getTotal(),
                                  //       style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // if (controller.booking.value.total_amount > controller.booking.value.total_payable_amount)
                                          //   Align(
                                          //     alignment: AlignmentDirectional.centerEnd,
                                          //     child: Ui.getPrice(
                                          //       controller.booking.value.total_amount,
                                          //       style: Get.textTheme.headline6.merge(TextStyle(
                                          //         color: Colors.grey,
                                          //         decoration: TextDecoration.lineThrough,
                                          //       )),
                                          //     ),
                                          //   ),
                                          // SizedBox(
                                          //   width: 5,
                                          // ),
                                          // Align(
                                          //   alignment: AlignmentDirectional.centerEnd,
                                          //   child: Ui.getPrice(
                                          //     controller.booking.value.total_payable_amount,
                                          //     style: Get.textTheme.headline6.merge(TextStyle(color: Colors.grey)),
                                          //   ),
                                          // ),

                                          // BookingRowWidget(
                                          //     descriptionFlex: 2,
                                          //     valueFlex: 1,
                                          //     description: controller.booking.value.eService.name,
                                          //     child: Align(
                                          //       alignment: Alignment.centerRight,
                                          //       child: Ui.getPrice(controller.booking.value.total_payable_amount,, style: Get.textTheme.subtitle2),
                                          //     ),
                                          //     hasDivider: true),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Ui.getPrice(controller.booking.value.total_payable_amount, style: Get.textTheme.subtitle2),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              // For Service Charge
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Expanded(
                              //       flex: 1,
                              //       child: Text(
                              //         "Service Charge".tr,
                              //         maxLines: 1,
                              //         overflow: TextOverflow.fade,
                              //         softWrap: false,
                              //         style: Get.textTheme.bodyText1,
                              //       ),
                              //     ),
                              //     Expanded(
                              //         flex: 1,
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.end,
                              //           children: [
                              //             Align(
                              //               alignment: Alignment.centerRight,
                              //               child: Ui.getPrice(5, style: Get.textTheme.subtitle2),
                              //             ),
                              //           ],
                              //         ),
                              //     ),
                              //   ],
                              // ),
                              // DropDown Menu
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Expanded(
                              //       flex: 1,
                              //       child: Text(
                              //         "TIP".tr,
                              //         maxLines: 1,
                              //         overflow: TextOverflow.fade,
                              //         softWrap: false,
                              //         style: Get.textTheme.bodyText1,
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.end,
                              //         children: [
                              //           // Text('TIP:'),
                              //           DropdownButton<String>(
                              //             value: selectedOption.value,
                              //             onChanged: (String value) async {
                              //               if (value == 'YES') {
                              //                 await _showTipDialog(context);
                              //                 await _dialogCompleter.future; // Wait for the dialog to complete
                              //               } else {
                              //                 selectedOption.value = value;
                              //               }
                              //             },
                              //             items: ['YES', 'NO'].map((String value) {
                              //               return DropdownMenuItem<String>(
                              //                 value: value,
                              //                 child: Text(value),
                              //               );
                              //             }).toList(),
                              //           ),
                              //           SizedBox(width: 20),
                              //           ValueListenableBuilder<String>(
                              //             valueListenable: tipText,
                              //             builder: (context, value, child) {
                              //               return Text(selectedOption.value == 'YES' ? value : '');
                              //             },
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // TextField(
                              //   controller: textFieldController,
                              //   keyboardType: TextInputType.number,
                              //   onChanged: (String text) {
                              //     tipController.setTipText(text);
                              //   },
                              //   decoration: InputDecoration(
                              //     hintText: 'Enter tip amount',
                              //   ),
                              // ),
                              // SizedBox(width: 20),
                              // Text(textFieldController.text),
                            ],
                          ),
                        );
                    })
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget buildBookingTitleBarWidget(Rx<BookingNew> _booking) {
    return Obx(() {
      return Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _booking.value.eService?.name ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 5),
                Text(
                  "- ${_booking.value.options?.name?.en ?? ''}",
                  style: Get.textTheme.headline5.merge(TextStyle(fontSize: 12, color: Colors.grey)),
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                ),
                Row(
                  children: [
                    Icon(Icons.person_outline, color: Get.theme.focusColor),
                    SizedBox(width: 8),
                    Text(
                      _booking.value.user?.name ?? '',
                      style: Get.textTheme.bodyText1,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.place_outlined, color: Get.theme.focusColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(_booking.value.address?.address ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodyText1),
                    ),
                  ],
                  // spacing: 8,
                  // crossAxisAlignment: WrapCrossAlignment.center,
                ),
              ],
            ),
          ),
          if (_booking.value.bookingAt == null)
            Container(
              width: 80,
              child: SizedBox.shrink(),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            ),
          if (_booking.value.bookingAt != null)
            Container(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.value.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  Text(DateFormat('dd', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
                      maxLines: 1,
                      style: Get.textTheme.headline3.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  Text(DateFormat('MMM', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                ],
              ),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            ),
        ],
      );
    });
    // return BookingTitleBarWidget(
    //   title: Container(height: 200, color: Colors.blue,)
    //   Obx(() {
    //     return Row(
    //       children: [
    //         Flexible(
    //           fit: FlexFit.tight,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               Text(
    //                 _booking.value.eService?.name ?? '',
    //                 style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
    //                 overflow: TextOverflow.fade,
    //               ),
    //               SizedBox(height: 5),
    //               Text(
    //                 "- ${_booking.value.options?.name?.en ?? ''}",
    //                 style: Get.textTheme.headline5.merge(TextStyle(fontSize: 12, color: Colors.grey)),
    //                 overflow: TextOverflow.fade,
    //                 maxLines: 3,
    //               ),
    //               Row(
    //                 children: [
    //                   Icon(Icons.person_outline, color: Get.theme.focusColor),
    //                   SizedBox(width: 8),
    //                   Text(
    //                     _booking.value.user?.name ?? '',
    //                     style: Get.textTheme.bodyText1,
    //                     maxLines: 1,
    //                     overflow: TextOverflow.fade,
    //                   ),
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   Icon(Icons.place_outlined, color: Get.theme.focusColor),
    //                   SizedBox(width: 8),
    //                   Expanded(
    //                     child: Text(_booking.value.address?.address ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodyText1),
    //                   ),
    //                 ],
    //                 // spacing: 8,
    //                 // crossAxisAlignment: WrapCrossAlignment.center,
    //               ),
    //             ],
    //           ),
    //         ),
    //         if (_booking.value.bookingAt == null)
    //           Container(
    //             width: 80,
    //             child: SizedBox.shrink(),
    //             decoration: BoxDecoration(
    //               color: Get.theme.colorScheme.secondary.withOpacity(0.2),
    //               borderRadius: BorderRadius.all(Radius.circular(10)),
    //             ),
    //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
    //           ),
    //         if (_booking.value.bookingAt != null)
    //           Container(
    //             width: 80,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.value.bookingAt),
    //                     maxLines: 1,
    //                     style: Get.textTheme.bodyText2.merge(
    //                       TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4),
    //                     ),
    //                     softWrap: false,
    //                     textAlign: TextAlign.center,
    //                     overflow: TextOverflow.fade),
    //                 Text(DateFormat('dd', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
    //                     maxLines: 1,
    //                     style: Get.textTheme.headline3.merge(
    //                       TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
    //                     ),
    //                     softWrap: false,
    //                     textAlign: TextAlign.center,
    //                     overflow: TextOverflow.fade),
    //                 Text(DateFormat('MMM', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
    //                     maxLines: 1,
    //                     style: Get.textTheme.bodyText2.merge(
    //                       TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
    //                     ),
    //                     softWrap: false,
    //                     textAlign: TextAlign.center,
    //                     overflow: TextOverflow.fade),
    //               ],
    //             ),
    //             decoration: BoxDecoration(
    //               color: Get.theme.colorScheme.secondary.withOpacity(0.2),
    //               borderRadius: BorderRadius.all(Radius.circular(10)),
    //             ),
    //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
    //           ),
    //       ],
    //     );
    //   }
    //   ),
    // );
  }

  BookingTitleBarWidget buildBookingTitleBarWidgetOld(Rx<BookingNew> _booking) {
    return BookingTitleBarWidget(
      title: Obx(() {
        return Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _booking.value.eService?.name ?? '',
                    style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "- ${_booking.value.options?.name?.en ?? ''}",
                    style: Get.textTheme.headline5.merge(TextStyle(fontSize: 12, color: Colors.grey)),
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Text(
                        _booking.value.user?.name ?? '',
                        style: Get.textTheme.bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      // Provider name
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(_booking.value.address?.address ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodyText1),
                      ),
                    ],
                    // spacing: 8,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                ],
              ),
            ),
            if (_booking.value.bookingAt == null)
              Container(
                width: 80,
                child: SizedBox.shrink(),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
            if (_booking.value.bookingAt != null)
              Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.value.bookingAt),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(DateFormat('dd', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.headline3.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(DateFormat('MMM', Get.locale.toString()).format(_booking.value.bookingAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
          ],
        );
      }),
    );
  }

  Container buildContactProvider(BookingNew _booking) {
    var _booking2 = controller.booking;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Provider".tr, style: Get.textTheme.subtitle2),
                // Text(_booking.eProvider?.phoneNumber ?? '', style: Get.textTheme.caption),
              ],
            ),
          ),
          if (_booking2.value.status != null && Get.find<GlobalService>().global.value.done != null)
            if(_booking2.value.status.order != Get.find<GlobalService>().global.value.done)
              Wrap(
                spacing: 5,
                children: [
                  MaterialButton(
                    onPressed: () {
                      launch("tel:${_booking.eProvider?.phoneNumber ?? ''}");
                    },
                    height: 44,
                    minWidth: 44,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                    child: Icon(
                      Icons.phone_android_outlined,
                      color: Get.theme.colorScheme.secondary,
                    ),
                    elevation: 0,
                  ),
                  Obx(() {
                    return controller.loadingStartChat.value
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            onPressed: () {
                              controller.startChat();
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                            padding: EdgeInsets.zero,
                            height: 44,
                            minWidth: 44,
                            child: Icon(
                              Icons.chat_outlined,
                              color: Get.theme.colorScheme.secondary,
                            ),
                            elevation: 0,
                          );
                  })
                ],
              )
        ],
      ),
    );
  }
}
