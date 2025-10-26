import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_services/app/modules/service_request/views/payrequest2.dart';
import 'package:home_services/app/modules/service_request/views/providers_list_widget.dart';
import '../../../../common/log_data.dart';
import '../../../../common/place_picker_dialog.dart';
import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/order_request_reponse_model_booking_id.dart';
import '../../../models/service_details_model.dart';
import '../../../providers/api_provider.dart';
import '../../../providers/laravel_provider.dart';
import '../../../repositories/booking_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_service.dart';
import '../../../services/settings_service.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../new_payment_ui/PaymentAndRequest.dart';
import '../../new_payment_ui/temp/payrequest.dart';
import '../controllers/RequestController.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:http/http.dart' as http;
import '../controllers/ServiceRequestController.dart' as svc;

import '../../../models/order_request_reponse_model_booking_id.dart' as OrderRequestResponseModelBookingId;

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

import 'ssl_payment.dart';

class RequestView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestViewState();
  }
}

class RequestViewState extends State<RequestView> {
  RequestController controller = Get.put(RequestController());
  final AddToCartController _addToCartController = Get.put(AddToCartController());

  initData() async {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(Duration(seconds: 1)).then((value) {
    //
    //   });
    // });
    controller.initData();
  }

  String name = "";
  String email = "";
  String phoneNumber = "";
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();
  List<String> sn = [];
  Set<String> serviceNames = {};
  String serviceNamesString = "";
  int bookingId = 0;
  int orderId = 0;


  Future<void> _fetchData() async {
    final response = await _laravelApiClient.fetchUserData();
    if (response.isNotEmpty) {
      setState(() {
        var _responseData = response;
        Map<String, dynamic> responseDataMap = json.decode(_responseData);

        Map<String, dynamic> data = responseDataMap['data'];

        // Extract name, email, and phone_number
        name = data['name'];
        email = data['email'];
        phoneNumber = data['phone_number'];

        print('Name: $name');
        print('Email: $email');
        print('Phone Number: $phoneNumber');
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchServiceName() async {
    var addToCardData = _addToCartController.addToCartData;

    // Extract unique service names from addToCardData
    for (AddToCart item in addToCardData) {
      serviceNames.add(item.service_name);
      sn.add(item.service_name);
    }

    // Convert the Set to a comma-separated string
    serviceNamesString = serviceNames.join(', ');

    print("FIND $serviceNamesString");
  }

  Future<void> _getBookigId()async{
    var response = await controller.submitBookingRequest2(_addToCartController.addToCartData);
    bookingId = _laravelApiClient.valueForResponse;
    orderId = _laravelApiClient.valueForOrderId;
    setState(() {});
  }

  // Future<void> _getBookigId()async{
  //   var response = await controller.submitBookingRequest2(_addToCartController.addToCartData);
  //   bookingId = _laravelApiClient.valueForResponse;
  //   orderId = _laravelApiClient.valueForOrderId;
  //   // setState(() {});
  //
  //   if(bookingId == 0){
  //     await controller.submitBookingRequest2(_addToCartController.addToCartData);
  //     bookingId = _laravelApiClient.valueForResponse;
  //     orderId = _laravelApiClient.valueForOrderId;
  //     setState(() {});
  //   }
  //   else{
  //     bookingId = _laravelApiClient.valueForResponse;
  //     orderId = _laravelApiClient.valueForOrderId;
  //     setState(() {});
  //   }
  //
  //   // print("BOOKINGVALUENNNN");
  //   // print(bookingId);
  //   // print(orderId);
  // }

  @override
  void initState() {
    // _getBookigId();
    _fetchData();
    initData();
    _getBookigId();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var orderTimeType = controller.orderTimeType;
    var orderRequestType = controller.orderRequestType;

    var selectedOrderTimeType = controller.selectedOrderTimeType;
    var selectedOrderRequestType = controller.selectedOrderRequestType;

    // var rrr = _laravelApiClient.submitBookingRequest();

    print("fsjfsads0001 ${orderTimeType.toString()}");
    print("fsjfsads0001 ${orderRequestType.toString()}");
    _fetchServiceName();

    return Scaffold(
      body: Container(
        color: Colors.grey.withOpacity(.15),
        child: RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshRequest(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: CustomScrollView(
              primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  title: Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Request'.tr,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  // backgroundColor: scrolled ? Colors.blue : Colors.red,
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.place_outlined,
                                color: Get.theme.colorScheme.secondary),
                            Text(
                              "Your Address",
                              style: TextStyle(
                                  color: Get.theme.colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Obx(() {
                                      return Text(
                                          controller.currentAddress?.value
                                                  ?.address ??
                                              "Loading...".tr,
                                          style: Get.textTheme.bodyText2);
                                    }))),
                            GestureDetector(
                              onTap: () {
                                // Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                                // showPlacePicker();
                                if(Platform.isAndroid) {
                                  Get.dialog(Dialog(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Location Permission".tr,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '"Live location" needs background location permission , for using Google map for live direction to reach to the location where event is being organised for the person who booked the service from our app.'
                                                  .tr,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    color: Colors.grey.shade300,
                                                    height: 50,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Cancel".tr,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.back();
                                                    showPlacePicker();
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    color: Get.theme.colorScheme
                                                        .secondary,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Okay".tr,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ));
                                }else{
                                  showPlacePicker();
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(0.30),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.gps_fixed,
                                      color: Get.theme.colorScheme.secondary,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Change",
                                      style: TextStyle(
                                          color:
                                              Get.theme.colorScheme.secondary),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          if (controller.addresses.isEmpty) {
                            return TabBarLoadingWidget();
                          } else {
                            print(
                                "sdnfjsfsdan  Get.find<SettingsService>().address: ${controller.currentAddress?.value?.address}");
                            return TabBarWidget(
                              initialSelectedId: "0",
                              tag: 'addresses',
                              tabs: List.generate(controller.addresses.length,
                                  (index) {
                                final _address =
                                    controller.addresses.elementAt(index);
                                return ChipWidget(
                                  tag: 'addresses',
                                  text: _address.getDescription,
                                  id: index,
                                  onSelected: (id) {
                                    Get.find<SettingsService>().address.value =
                                        _address;
                                    controller.currentAddress.value = _address;
                                    controller.refreshRequest(
                                        showMessage: true);
                                  },
                                );
                              }),
                            );
                          }
                        }),
                        SizedBox(
                          height: 20,
                        ),
                        buildNoteInputField(),
                        SizedBox(
                          height: 20,
                        ),
                        buildCouponField(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 14, right: 7),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButtonFormField(
                              hint: Text("Select Time Schedule".tr),
                              iconEnabledColor: Get.theme.colorScheme.secondary,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                              ),
                              dropdownColor: Colors.white,
                              onChanged: (value) {
                                print("ksdfnasj $value");
                                controller.selectedOrderTimeType.value = value;
                                if (value.toString() == "As Soon As Possible") {
                                  controller.bookingAt.value = DateTime.now();
                                }
                              },
                              items: orderTimeType),
                        ),
                        Obx(() {
                          DateTime bookingAt = controller.bookingAt.value;
                          return selectedOrderTimeType == "Schedule An Order"
                              ? Column(
                                  children: [
                                    Divider(
                                      height: 1,
                                      color: Colors.grey.withOpacity(.15),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Date",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  controller.showMyDatePicker(
                                                      context);
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .date_range_outlined),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        '${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(bookingAt)}')
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Time",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  controller.showMyTimePicker(
                                                      context);
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .watch_later_outlined),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        "${DateFormat('HH:mm', Get.locale.toString()).format(bookingAt)}")
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container();
                        }),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(left: 14, right: 7),
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(4)),
                        //   child: DropdownButtonFormField(
                        //       hint: Text("Select Request Type".tr),
                        //       iconEnabledColor: Get.theme.colorScheme.secondary,
                        //       decoration: InputDecoration(
                        //         enabledBorder: UnderlineInputBorder(
                        //             borderSide:
                        //                 BorderSide(color: Colors.white)),
                        //         disabledBorder: UnderlineInputBorder(
                        //             borderSide:
                        //                 BorderSide(color: Colors.white)),
                        //         focusedBorder: UnderlineInputBorder(
                        //             borderSide:
                        //                 BorderSide(color: Colors.white)),
                        //       ),
                        //       dropdownColor: Colors.white,
                        //       onChanged: (value) {
                        //         print("ksdfnasj $value");
                        //         controller.selectedOrderRequestType.value =
                        //             value;
                        //       },
                        //       items: orderRequestType),
                        // ),
                        // Obx(() {
                        //   return selectedOrderRequestType ==
                        //               "Choose Provider Manually" &&
                        //           controller.providersData.length > 0
                        //       ? Container(
                        //           margin: EdgeInsets.only(top: 15, bottom: 15),
                        //           child: MediaQuery.removePadding(
                        //             context: context,
                        //             removeTop: true,
                        //             child: ListView.builder(
                        //               primary: false,
                        //               shrinkWrap: true,
                        //               scrollDirection: Axis.vertical,
                        //               itemBuilder: (_, index) {
                        //                 return Container(
                        //                     child: ProvidersListWidget(
                        //                   // data: controller.providersDataWithServiceName[index],
                        //                   data: controller.providersData[index],
                        //                   serviceIndex: index,
                        //                 ));
                        //               },
                        //               itemCount:
                        //                   controller.providersData.length,
                        //             ),
                        //           ),
                        //         )
                        //       : Container();
                        // }),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 50,
          // color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "${_addToCartController.addToCartData.length} ${_addToCartController.addToCartData.length > 1 ? "Services".tr : "Service".tr}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w100),
                    ),
                    Text(
                      " | ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "${_addToCartController.totalAmount().toStringAsFixed(3)}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),

               InkWell(
                  onTap: () {
                    if (serviceNames.length > 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please Select only one Item at a time.",
                            style: TextStyle(color: Colors.red), // Set text color to red
                          ),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    } else {
                      if (Get.find<SettingsService>().address.value.isUnknown()) {
                        Get.showSnackbar(Ui.ErrorSnackBar(
                          message: "Please set your location",
                        ));
                      }
                      else {
                        Get.to(() => sslpayment(
                            bookingId: bookingId,
                            orderId: orderId,
                            name: name,
                            address: Get.find<SettingsService>().address.value.address.toString(),
                            phoneNumber: phoneNumber,
                            email: email,
                            amount: _addToCartController.totalAmount(),
                            totalPayableAmount: 5.0,
                            serviceAmount: '5',
                            service_info: serviceNamesString
                        ));
                      }
                      // else {
                      //   Get.to(() => sslpayment(
                      //       bookingId: bookingId,
                      //       orderId: orderId,
                      //       name: name,
                      //       address: Get.find<SettingsService>().address.value.address.toString(),
                      //       phoneNumber: phoneNumber,
                      //       email: email,
                      //       amount: _addToCartController.totalAmount(),
                      //       totalPayableAmount: 5.0,
                      //       serviceAmount: '5',
                      //       service_info: serviceNamesString
                      //   ));
                      // }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Pay & Send Request".tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),


                // Request and payment part

                // controller.isSubmitOrderLoading.value == true
                //     ? CircularProgressIndicator()
                //     : InkWell(
                //   onTap: () {
                //     if (Get.find<SettingsService>().address.value.isUnknown()) {
                //       Get.showSnackbar(Ui.ErrorSnackBar(
                //         message: "Please set your location",
                //       ));
                //     } else {
                //       Get.to(() => payrequest2(name: name, address: Get.find<SettingsService>().address.value.address.toString(),
                //       phoneNumber: phoneNumber, email: email, amount: _addToCartController.totalAmount(), totalPayableAmount: 5.0,
                //       serviceAmount: '5', service_info: serviceNamesString));
                //     }
                //   },
                //
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //     decoration: BoxDecoration(
                //       color: Get.theme.colorScheme.secondary,
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Text(
                //       "Pay & Send Request".tr,
                //       style: TextStyle(
                //         fontSize: 14,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),


                // ONLY REQUEST PART

                // controller.isSubmitOrderLoading.value == true
                //     ? CircularProgressIndicator()
                //
                // :InkWell(
                //         onTap: () {
                //           if (Get.find<SettingsService>()
                //               .address
                //               .value
                //               .isUnknown()) {
                //             Get.showSnackbar(Ui.ErrorSnackBar(
                //                 message: "Please set your location"));
                //           }
                //           else {
                //             if (selectedOrderRequestType !=
                //                 "Choose Provider Manually") {
                //               controller.submitBookingRequest(
                //                   _addToCartController.addToCartData);
                //             }
                //             if (selectedOrderRequestType ==
                //                     "Choose Provider Manually" &&
                //                 controller.providersData.length > 0) {
                //               // controller.validateManualBookingRequest(
                //               //     _addToCartController.addToCartData);
                //             }
                //           }
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(
                //               left: 20, right: 20, top: 10, bottom: 10),
                //           decoration: BoxDecoration(
                //             color: Get.theme.colorScheme.secondary,
                //             borderRadius: BorderRadius.all(Radius.circular(20)),
                //           ),
                //           child: Text("Request".tr,
                //               style: (TextStyle(
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.white))),
                //         ),
                //       )
              ],
            );
          })),
    );
  }

  Widget buildNoteInputField() {
    return Hero(
      tag: Get.arguments ?? '',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Get.theme.colorScheme.secondary.withOpacity(.50),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Container(
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, left: 0),
                  child: Icon(
                    Icons.sticky_note_2_outlined,
                    color: Get.theme.colorScheme.secondary,
                    size: 28,
                  ),
                ),
              ),
              Expanded(
                // child: Material(
                child: TextField(
                  controller: controller.noteEditingController,
                  autofocus: false,
                  // onChanged:  controller.onChangeHandler,
                  // clipBehavior: HitTestBehavior.translucent,
                  style: Get.textTheme.bodyText2,
                  onSubmitted: (value) {
                    // controller.searchEServices(keywords: value);
                  },
                  cursorColor: Get.theme.focusColor,
                  decoration: Ui.getInputDecoration(
                    hintText:
                        "Write here if you have any extra requirements.".tr,
                  ),
                ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCouponField() {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Hero(
            tag: Get.arguments ?? '',
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.theme.colorScheme.secondary.withOpacity(.50),
                  ),
                  borderRadius: BorderRadius.circular(4)),
              child: Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: Icon(
                          Icons.local_offer_outlined,
                          color: Get.theme.colorScheme.secondary,
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      // child: Material(
                      child: TextFormField(
                        controller: controller.couponEditingController,
                        // onChanged:  controller.onChangeHandler,
                        // clipBehavior: HitTestBehavior.translucent,
                        style: Get.textTheme.bodyText2,
                        // onSubmitted: (value) {
                        //   // controller.searchEServices(keywords: value);
                        // },
                        // onChanged: (input) => controller.oldPassword.value = input,
                        // validator: (input) => input.length < 1 ? "Enter a valid promo code".tr : null,
                        autofocus: false,
                        cursorColor: Get.theme.focusColor,
                        decoration: Ui.getInputDecoration(
                          hintText: "Enter your coupon here.".tr,
                        ),
                      ),
                      // ),
                    ),
                    Obx(() {
                      return controller.isLoading.value
                          ? CircularProgressIndicator()
                          : Container(
                              margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 7, bottom: 7),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary
                                    .withOpacity(0.30),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // if (_formKey.currentState.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  if (controller.couponEditingController.text
                                          .trim()
                                          .length >
                                      1) {
                                    controller.validateCoupon();
                                  } else {
                                    Get.showSnackbar(Ui.ErrorSnackBar(
                                        message:
                                            "You haven't entered any coupon code!"));
                                  }

                                  // }
                                },
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      color: Get.theme.colorScheme.secondary),
                                ),
                              ),
                            );
                    })
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            return controller.coupon.value != null &&
                    controller.coupon.value.code != null
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Applied Coupon: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.clearCoupon();
                          },
                          child: Container(
                            // margin: EdgeInsets.only(top: 10),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    // behavior: HitTestBehavior.translucent,
                                    child: InkWell(
                                      child: Container(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  clipBehavior: Clip.none,
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 7, bottom: 7),
                                  decoration: BoxDecoration(
                                    color: Get.theme.colorScheme.secondary
                                        .withOpacity(0.10),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    "${controller.coupon.value.code}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          })
        ],
      ),
    );
  }
}
