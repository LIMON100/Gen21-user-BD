import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/manual_order_model.dart';
import '../../../models/option_model.dart';
import '../../../models/order_request_channel.dart';
import '../../../models/order_request_model.dart';
import '../../../models/order_request_response_model.dart' as OrderRequestResponseModel;
import '../../../models/order_request_reponse_model_booking_id.dart' as OrderRequestResponseModelBookingId;

import '../../../models/order_update_pusher_event.dart';
import '../../../models/provider_model.dart' as ProvidersDataWithServiceName;
import '../../../models/provider_model.dart' as SingleProvider;
import '../../../models/providers_model.dart';
import '../../../models/requested_service_model.dart';
import '../../../providers/database_helper.dart';
import '../../../repositories/cart_repository.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/provider_repository.dart';
import '../../../repositories/request_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../home/widgets/welcome_widget.dart';
import '../../orders/orders_controller/orders_controller.dart';
import '../../root/controllers/root_controller.dart';
import '../widgets/bottomsheet_widget.dart';
import '../widgets/welcome_widget_test.dart';

import 'package:provider/provider.dart';

class RequestController extends GetxController {

  ProviderRepository _providerRepository;
  RequestRepository _requestRepository;
  final addresses = <Address>[].obs;
  SettingRepository _settingRepository;
  var bookingAt = DateTime.now().obs;

  // var addToCartData = List<AddToCart>().obs;

  // var orderTimeType = ["As soon as possible", "Schedule a time"].obs;
  List<DropdownMenuItem<String>> orderTimeType = [
    DropdownMenuItem(
        child: Text("As Soon As Possible"), value: "As Soon As Possible"),
    DropdownMenuItem(
        child: Text("Schedule An Order"), value: "Schedule An Order"),
  ];

  List<DropdownMenuItem<String>> orderRequestType = [
    DropdownMenuItem(
        child: Text("Request To System"), value: "Request To System"),
    DropdownMenuItem(
        child: Text("Choose Provider Manually"),
        value: "Choose Provider Manually"),
  ];

  var time = "".obs;
  var date = "".obs;
  var selectedOrderTimeType = "".obs;
  var selectedOrderRequestType = "".obs;

  var providersData = <Data>[].obs;

  // var providersDataWithServiceName = <ProvidersDataWithServiceName.Data>[].obs;

  TextEditingController noteEditingController, couponEditingController;

  // var orderRequestResponse = OrderRequestResponseModel.OrderRequestResponse().obs;

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  var pusherChannelSubscriptionStatus = "".obs;

  // Address get currentAddress => Get.find<SettingsService>().address.value;

  var currentAddress = Rx<Address>(null);
  // var addToCartObs =  AddToCart().obs;

  final AddToCartController _addToCartController =
      Get.put(AddToCartController());

  var coupon = Coupon().obs;

  var isLoading = false.obs;

  var isSubmitOrderLoading = false.obs;
  var isSubmit2OrderLoading = false.obs;

  var orderRequestResponse =
      OrderRequestResponseModel.OrderRequestResponse().obs;

  var apiResponse =
      OrderRequestResponseModelBookingId.ApiResponse().obs;

  var selectedProviders = <SelectedServiceProvider>[].obs;

  // var orderedServiceList = <OrderRequestResponseModel.Service>[].obs;

  RequestController() {
    _providerRepository = new ProviderRepository();
    _requestRepository = new RequestRepository();
    _settingRepository = SettingRepository();
    noteEditingController = new TextEditingController();
    couponEditingController = new TextEditingController();
  }

  // @override
  // Future<void> onInit() async {
  //   this.selectedOrderTimeType.value = orderTimeType[0].value;
  //   this.selectedOrderRequestType.value = orderRequestType[0].value;
  //   super.onInit();
  // }

  // @override
  // void onInit() async {
  //   // var arguments = Get.arguments as Map<String, dynamic>;
  //   // print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
  //   // heroTag.value = arguments['heroTag'] as String;
  //   // _searchSuggestion = arguments['searchSuggestion'] as SearchSuggestion;
  //   // print("KYToitojuu _searchSuggestion ServiceController ${_searchSuggestion.toString()}");
  //   // this.selectedOrderTimeType.value = orderTimeType[0].value;
  //   // this.selectedOrderRequestType.value = orderRequestType[0].value;
  //
  //   try {} catch (e) {}
  //
  //   pusherInit();
  //   await getAddresses();
  //   super.onInit();
  // }
  Future initData() async {
    pusherInit();
    currentAddress.value = Get.find<SettingsService>().address.value;
    await getAddresses();
    // currentAddress.value = Get.find<SettingsService>().address.value;
    // super.onInit();
  }

  @override
  void onReady() async {
    print("fsjfsads0");
    await refreshRequest();
    super.onReady();
  }

  Future refreshRequest({bool showMessage = false}) async {
    print("fsjfsads1");

    // getService("1");

    searchProviders();
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  // Future searchProviders() async {
  //   print("fsjfsads3");
  //   providersDataWithServiceName.clear();
  //   OrderRequest orderRequest = new OrderRequest(couponEditingController.text, noteEditingController.text, currentAddress, _addToCartController.addToCartData);
  //   printWrapped("jnfajfdsja sending request: ${json.encode(orderRequest)}");
  //   providersData.value = await _providerRepository.searchProviders(data: json.encode(orderRequest));
  //   print("dfbhaadsa in getProviders() provider ${providersData.toString()}");
  //   // providers = provider.data;
  //
  //   for (int i = 0; i < providersData.length; i++) {
  //     var providerUsers = <Users>[];
  //     providersData[i].eProvider.forEach((element) {
  //       print("dfbhaadsa element.toString() ${element.toString()}");
  //       element.users.forEach((element) {
  //         print("dfbhaadsa user: ${element.toString()}");
  //         providerUsers.add(element);
  //       });
  //     });
  //
  //     print("dfbhaadsa in providerUsers ${providerUsers.toString()}");
  //     providersDataWithServiceName.add(new ProvidersDataWithServiceName.Data(title: providersData[i].name.en, providers: providerUsers));
  //   }
  //
  //   print("dfbhaadsa in providersDataWithServiceName ${providersDataWithServiceName.toString()}");
  //
  // }

  Future searchProviders() async {
    print("fsjfsads3");
    // providersDataWithServiceName.clear();
    // try {

    OrderRequest orderRequest = new OrderRequest(
        couponEditingController.text,
        noteEditingController.text,
        currentAddress.value,
        _addToCartController.addToCartData);
    printWrapped("jnfajfdsja sending request: ${json.encode(orderRequest)}");
    providersData.value = await _providerRepository.searchProviders(
        data: json.encode(orderRequest));
    print("dfbhaadsa in getProviders() provider ${providersData.toString()}");
    // providers = provider.data;

    // for (int i = 0; i < providersData.length; i++) {
    //   var providerUsers = <Users>[];
    //   providersData[i].eProvider.forEach((element) {
    //     print("dfbhaadsa element.toString() ${element.toString()}");
    //     element.users.forEach((element) {
    //       print("dfbhaadsa user: ${element.toString()}");
    //       providerUsers.add(element);
    //     });
    //   });
    //
    //   print("dfbhaadsa in providerUsers ${providerUsers.toString()}");
    //   providersDataWithServiceName.add(new ProvidersDataWithServiceName.Data(title: providersData[i].name.en, providers: providerUsers));
    // }

    // print("dfbhaadsa in providersDataWithServiceName ${providersDataWithServiceName.toString()}");
    // } catch (e) {
    //   print("fnanjdsa  in getProviders ${e.toString()}");
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  submitBookingRequest(List<AddToCart> data) async {
    try {
      pusherChannelSubscriptionStatus.value = "";
      isSubmitOrderLoading.value = true;
      // update();
      print("jdsnakkb currentAddress: ${currentAddress.toString()}");

      print("jsnfnanj cart dataaa: ${data.toString()}");

      List<RequestedService> reqData = [];
      for (int i = 0; i < data.length; i++) {
        AddToCart cart = data[i];
        reqData.add(RequestedService(
            id: cart.id,
            type: cart.type,
            service_name: cart.service_name,
            service_id: cart.service_id,
            name: cart.name,
            image_url: cart.image_url,
            price: cart.price,
            minimum_unit: cart.minimum_unit,
            added_unit: cart.added_unit,
            booking_at: bookingAt.value.toUtc().toString()));
      }
      printWrapped("sfnjanjdksakj sending Data22: ${json.encode(reqData)}");
      printWrapped("sfnjanjdksakj sending Data22: ${coupon}");

      OrderRequest orderRequest = new OrderRequest(
          coupon.value != null && coupon.value.code != null
              ? coupon.value.code
              : "",
          noteEditingController.text,
          currentAddress.value,
          reqData);

      // printWrapped("jnjsndfa sending Data3: ${json.encode(orderRequest)}");
      // printWrapped("jdnjksfajkf orderRequest.toString(): ${orderRequest.toString()}");
      printWrapped(
          "sfnjanjdksakj submitBookingRequest sending Data in user APP:${json.encode(orderRequest)}");

      orderRequestResponse.value = await _requestRepository
          .submitBookingRequest(data: json.encode(orderRequest));
      await _addToCartController.deleteAllCart();

      // Turn OFF AFTER calling submitRequest
      // Get.until((route) {
      //   return route.settings.name == Routes.ROOT;
      // });

      // Turn OFF to go the service request page
      // Get.toNamed(Routes.SERVICE_REQUESTS,
      //     arguments: {"service_requests": orderRequestResponse.value});

      isSubmitOrderLoading.value = false;

      // _requestRepository.submitBookingRequest(data: json.encode(orderRequest)).then((value) async {
      //   orderRequestResponse.value = value;
      //   await _addToCartController.deleteAllCart();
      //   Get.until((route) {
      //     print("shdgfsa ${route.toString()}");
      //     print("shdgfsa oute.settings.name: ${route.settings.name}");
      //     return route.settings.name == Routes.ROOT;
      //   });
      //   // Navigator.popUntil(context, (route) => route.isFirst);
      //   // Get.bottomSheet(TestBottomSheetWidget());
      //   // refresh();
      //   Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"service_requests": orderRequestResponse.value});
      //
      // });
    } catch (e) {
      pusherChannelSubscriptionStatus.value = "error";
      orderRequestResponse.value = null;
      print("jsnfnanj e: ${e.toString()}");
    }
  }

  submitBookingRequest2(List<AddToCart> data) async {
    try {
      pusherChannelSubscriptionStatus.value = "";
      isSubmit2OrderLoading.value = true;
      // update();
      print("jdsnakkb currentAddress: ${currentAddress.toString()}");

      print("jsnfnanj cart dataaa: ${data.toString()}");

      List<RequestedService> reqData = [];
      for (int i = 0; i < data.length; i++) {
        AddToCart cart = data[i];
        reqData.add(RequestedService(
            id: cart.id,
            type: cart.type,
            service_name: cart.service_name,
            service_id: cart.service_id,
            name: cart.name,
            image_url: cart.image_url,
            price: cart.price,
            minimum_unit: cart.minimum_unit,
            added_unit: cart.added_unit,
            booking_at: bookingAt.value.toUtc().toString()));
      }
      printWrapped("sfnjanjdksakj sending Data22: ${json.encode(reqData)}");
      printWrapped("sfnjanjdksakj sending Data22: ${coupon}");

      OrderRequest orderRequest = new OrderRequest(
          coupon.value != null && coupon.value.code != null
              ? coupon.value.code
              : "",
          noteEditingController.text,
          currentAddress.value,
          reqData);

      printWrapped(
          "sfnjanjdksakj submitBookingRequest sending Data in user APP:${json.encode(orderRequest)}");

      apiResponse.value = (await _requestRepository
          .submitBookingRequest2(data: json.encode(orderRequest))) as OrderRequestResponseModelBookingId.ApiResponse;
      await _addToCartController.deleteAllCart();

      // isSubmitOrderLoading.value = false;
      isSubmit2OrderLoading.value = true;

    } catch (e) {
      pusherChannelSubscriptionStatus.value = "error";
      apiResponse.value = null;
      print("jsnfnanj e: ${e.toString()}");
    }
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{3,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  // Widget getContent() {
  //   print("jsnfnanj getContent called");
  //   return Column(
  //     children: [
  //       Text("Your content goes here widget"),
  //       Text("Your content goes here widget"),
  //       Text("Your content goes here widget"),
  //       Text("Your content goes here widget"),
  //     ],
  //   );
  // }

  void pusherInit() async {
    try {
      await pusher.init(
        apiKey: "8dc6d2a858850abe4dbf",
        cluster: "mt1",
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        // onSubscriptionError: onSubscriptionError,
        // onDecryptionFailure: onDecryptionFailure,
        // onMemberAdded: onMemberAdded,
        // onMemberRemoved: onMemberRemoved,
        // authEndpoint: "<Your Authendpoint>",
        // onAuthorizer: onAuthorizer
      );
    } catch (e) {
      print("skfjdsann error: $e");
    }
  }

  void onEvent(PusherEvent event) {
    printWrapped("jfsdbakhfda userapp: onEventdata: ${event.toString()}");

    OrderUpdatePusherEvent pusherEvents =
        OrderUpdatePusherEvent.fromJson(jsonDecode(event.data));
    // print("jnfabhkio id: ${authService.userId}");
    // print("jnfabhkio apiToken: ${authService.apiToken}");

    pusherEvents.eventData.forEach((pusherEvent) {
      print("jfsdbakhfda in 1");
      if (pusherEvent.status.toString() == "accept") {
        orderRequestResponse.value.eventData.service.forEach((requestEvent) {
          if (requestEvent.serviceType == pusherEvent.serviceType &&
              requestEvent.eServiceId == pusherEvent.eServiceId) {
            print("jfsdbakhfda  ${pusherEvent.eServiceName} has been accepted");
            Get.back();
            if (Get.currentRoute == Routes.ROOT) {
              print("jfsdbakhfda  Routes.ROOT");
              Get.find<RootController>().currentIndex.value = 1;
            }

            Get.snackbar(
                "${pusherEvent.eServiceName} has been accepted", "See details");
          }
        });
      }
    });
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("skfjdsann onSubscriptionSucceeded: $channelName data: $data");
    pusherChannelSubscriptionStatus.value = "true";
  }

  void onSubscriptionError(String message, dynamic e) {
    print("skfjdsann onSubscriptionError: $message Exception: $e");
    pusherChannelSubscriptionStatus.value = "false";
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("kwnnasf Connection: $currentState");
    pusherChannelSubscriptionStatus.value = currentState;
  }

  void onError(String message, int code, dynamic e) {
    print("skfjdsann onError: $message code: $code exception: $e");
    pusherChannelSubscriptionStatus.value = "false";
  }

  connectToPusher() async {
    print("kwnnasf connectToPusher called");
    if (pusher.connectionState.capitalize == "CONNECTED") {
      await pusher.subscribe(
          channelName: "${orderRequestResponse.value.channelName}");
      await pusher.connect();
    } else {
      print("skfjdsann not connected: ${pusher.connectionState.toString()}");
      await pusher.subscribe(
          channelName: "${orderRequestResponse.value.channelName}");
      await pusher.connect();
    }
  }

  // Future getAddresses() async {
  //   try {
  //     if (Get.find<AuthService>().isAuth) {
  //       addresses.assignAll(await _settingRepository.getAddresses());
  //       if (!currentAddress.isUnknown()) {
  //         addresses.remove(currentAddress);
  //         addresses.insert(0, currentAddress);
  //       }
  //       if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
  //         Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id;
  //       }
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
  void showOrderAcceptedDialog() {}

  // Future<void> validateManualBookingRequest(List<AddToCart> data) async {
  //   List<ManualOrder> manualOrder = [];
  //   int providersNotSelected = 0;
  //   printWrapped("jdfauihjer data.length: ${data.length} providersDataWithServiceName.length: ${providersDataWithServiceName.length}");
  //   printWrapped("jdfauihjer data.toString: ${data.toString()} providersDataWithServiceName.toString: ${providersDataWithServiceName.toString()}");
  //
  //   for (int i = 0; i < data.length; i++) {
  //     if ("${providersDataWithServiceName[i].selectedIndex}" != "-1") {
  //       manualOrder.add(new ManualOrder(id: data[i].id, type: data[i].type, service_name: data[i].service_name, service_id: data[i].service_id, name: data[i].name, image_url: data[i].image_url, price: data[i].price, minimum_unit: data[i].minimum_unit, added_unit: data[i].added_unit, provider_id: "${providersDataWithServiceName[i].providers[int.parse(providersDataWithServiceName[i].selectedIndex.value)].id}"));
  //     } else {
  //       providersNotSelected++;
  //     }
  //   }
  //
  //   if (providersNotSelected > 0) {
  //     printWrapped("jdfauihjer providersNotSelected: $providersNotSelected ${manualOrder.toString()}");
  //     _showProvidersNotFound(Get.context, providersNotSelected, manualOrder);
  //   } else {
  //     printWrapped("jdfauihjer providersNotSelected: $providersNotSelected ${manualOrder.toString()}");
  //
  //     sendManualBookingRequest(manualOrder);
  //   }
  //
  //   // pusherChannelSubscriptionStatus.value = "";
  // }
  Future<void> validateManualBookingRequest(List<AddToCart> data) async {
    List<ManualOrder> manualOrder = [];
    int providersNotSelected = 0;
    // printWrapped("jdfauihjer data.length: ${data.length} providersDataWithServiceName.length: ${providersDataWithServiceName.length}");
    // printWrapped("jdfauihjer data.toString: ${data.toString()} providersDataWithServiceName.toString: ${providersDataWithServiceName.toString()}");

    // for (int i = 0; i < data.length; i++) {
    //   if ("${providersDataWithServiceName[i].selectedIndex}" != "-1") {
    //     manualOrder.add(new ManualOrder(id: data[i].id, type: data[i].type, service_name: data[i].service_name, service_id: data[i].service_id, name: data[i].name, image_url: data[i].image_url, price: data[i].price, minimum_unit: data[i].minimum_unit, added_unit: data[i].added_unit, provider_id: "${providersDataWithServiceName[i].providers[int.parse(providersDataWithServiceName[i].selectedIndex.value)].id}"));
    //   } else {
    //     providersNotSelected++;
    //   }
    // }
    //
    // if (providersNotSelected > 0) {
    //   printWrapped("jdfauihjer providersNotSelected: $providersNotSelected ${manualOrder.toString()}");
    //   _showProvidersNotFound(Get.context, providersNotSelected, manualOrder);
    // } else {
    //   printWrapped("jdfauihjer providersNotSelected: $providersNotSelected ${manualOrder.toString()}");
    //
    //   sendManualBookingRequest(manualOrder);
    // }

    for (int i = 0; i < data.length; i++) {
      String serviceName = data[i].service_name;
      print("jdnfjnsak ServiceName: $serviceName");

      String selectedProviderId =
          getSelectedProviderIdByServiceName(serviceName);
      print("jdnfjnsak selectedProviderId $selectedProviderId");
      if (selectedProviderId != "") {
        manualOrder.add(new ManualOrder(
            id: data[i].id,
            type: data[i].type,
            service_name: data[i].service_name,
            service_id: data[i].service_id,
            name: data[i].name,
            image_url: data[i].image_url,
            price: data[i].price,
            minimum_unit: data[i].minimum_unit,
            added_unit: data[i].added_unit,
            provider_id: selectedProviderId,
            booking_at: bookingAt.value.toUtc().toString()));
      } else {
        providersNotSelected++;
      }

      print("sdjfnkja ${manualOrder.toString()}");

      // else{
      //   manualOrder.add(new ManualOrder(id: data[i].id, type: data[i].type, service_name: data[i].service_name, service_id: data[i].service_id, name: data[i].name, image_url: data[i].image_url, price: data[i].price, minimum_unit: data[i].minimum_unit, added_unit: data[i].added_unit, provider_id: selectedProviderId));
      //
      // }
    }

    if (providersNotSelected > 0) {
      printWrapped(
          "jdfauihjer providersNotSelected: $providersNotSelected ${manualOrder.toString()}");
      _showProvidersNotFound(Get.context, providersNotSelected, manualOrder);
    } else {
      printWrapped(
          "jdfauihjer providersNotSelected: $providersNotSelected ${manualOrder.toString()}");

      sendManualBookingRequest(manualOrder);
    }

    // pusherChannelSubscriptionStatus.value = "";
  }

  void _showProvidersNotFound(BuildContext context,
      int noOfProvidersUnAvailability, List<ManualOrder> data) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Providers not found for $noOfProvidersUnAvailability service",
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Do you want to order for other services".tr,
                    style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Yes".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                sendManualBookingRequest(data);
                // Get.back();
                // controller.deleteWallet(controller.wallet.value);
              },
            ),
          ],
        );
      },
    );
  }

  sendManualBookingRequest(List<ManualOrder> data) {
    try {
      isSubmitOrderLoading.value = true;
      print("jdsnakkb currentAddress: ${currentAddress.toString()}");
      print("jsnfnanj cart dataaa: ${data.toString()}");

      OrderRequest orderRequest = new OrderRequest(
          coupon.value != null && coupon.value.code != null
              ? coupon.value.code
              : "",
          noteEditingController.text,
          currentAddress.value,
          data
      );

      printWrapped("jnjsndfa sending Data3: ${json.encode(orderRequest)}");
      _requestRepository
          .submitManualBookingRequest(data: json.encode(orderRequest))
          .then((value) {
        isSubmitOrderLoading.value = false;
        if (value == true) {
          Get.showSnackbar(
              Ui.SuccessSnackBar(message: "Order Booked successfully".tr));
          Get.until((route) {
            print("shdgfsa ${route.toString()}");
            print("shdgfsa oute.settings.name: ${route.settings.name}");
            return route.settings.name == Routes.ROOT;
          });
          if (Get.isRegistered<OrdersController>()) {
            Get.find<OrdersController>().refreshOrders();
            Get.find<RootController>().changePage(1);
          }
        } else {
          Get.showSnackbar(
              Ui.ErrorSnackBar(message: "Something went wrong".tr));
        }

        // Navigator.popUntil(context, (route) => route.isFirst);
        // Get.bottomSheet(TestBottomSheetWidget());
        // refresh();
        // connectToPusher();
      });
    } catch (e) {
      // pusherChannelSubscriptionStatus.value = "error";
      // requestChannel.value = null;
      isSubmitOrderLoading.value = false;
      print("jsnfnanj e: ${e.toString()}");
    }
  }

  Future getAddresses() async {
    // try {
      if (Get.find<AuthService>().isAuth) {

        addresses.assignAll(await _settingRepository.getAddresses());
        if (currentAddress.value != null &&  !currentAddress.value.isUnknown()) {
          // addresses.remove(currentAddress);
          addresses.insert(0, currentAddress.value);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id;
          Get.find<SettingsService>().address.value = addresses.elementAt(0);
          currentAddress.value = addresses.elementAt(0);
          printWrapped("gen21 log currentAddress: ${currentAddress.toString()}");

        }

        if(addresses.isNotEmpty){
          currentAddress.value = addresses.elementAt(0);
        }
      }
    // } catch (e) {
    //   print("sjdbnhsbh e: ${e.toString()}");
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  void validateCoupon() async {
    try {
      isLoading.value = true;
      coupon.value = null;
      coupon.value = await _requestRepository
          .validateCouponByCode(couponEditingController.text);
      // booking.update((val) {
      //   val.coupon = _coupon;
      // });
      print("kjsdnkfa ${coupon.toString()}");
      update();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void clearCoupon() {
    print("sdfjabhhs cleaing coupon");
    coupon.value = null;

    update();
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      bookingAt.value = DateTime(picked.year, picked.month, picked.day,
          bookingAt.value.hour, bookingAt.value.minute);
      // booking.update((val) {
      //   val.bookingAt = DateTime(picked.year, picked.month, picked.day, val.bookingAt.hour, val.bookingAt.minute);
      //   ;
      // });
    }
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      bookingAt.value = DateTime(
              bookingAt.value.year, bookingAt.value.month, bookingAt.value.day)
          .add(Duration(minutes: picked.minute + picked.hour * 60));
      // booking.update((val) {
      //   val.bookingAt = DateTime(booking.value.bookingAt.year, booking.value.bookingAt.month, booking.value.bookingAt.day).add(Duration(minutes: picked.minute + picked.hour * 60));
      // });
    }
  }

  // updateSelectProviders( String serviceName, String providerId) {
  //   int index = selectedProviders.indexWhere((element) => element.serviceName == serviceName &&  element.providerId == providerId);
  //   print("sdjfnkja matched dataIndex: $index");
  //   print("sdjfnkja providers before Changes: ${selectedProviders.toString()}");
  //   if (index == -1) {
  //     selectedProviders.add(SelectedServiceProvider(serviceName: serviceName, providerId: providerId));
  //   }
  //   print("sdjfnkja providers after changes: ${selectedProviders.toString()}");
  // }

  updateSelectProviders(
      int serviceIndex, int itemIndex, String serviceName, String providerId) {
    print("sdjfnkja providers before Changes: ${selectedProviders.toString()}");
    selectedProviders
        .removeWhere((element) => element.serviceIndex == serviceIndex);
    if (providersData[serviceIndex].selectedIndex.value == "$itemIndex") {
      providersData[serviceIndex].selectedIndex.value = "-1";
    } else {
      providersData[serviceIndex].selectedIndex.value = "$itemIndex";
      selectedProviders.add(SelectedServiceProvider(
          serviceIndex: serviceIndex,
          itemIndex: itemIndex,
          serviceName: serviceName,
          providerId: providerId));
    }
    update();
    print(
        "sdjfnkja providers after changes length: ${selectedProviders.length} serviceIndex: $serviceIndex index: $itemIndex ${selectedProviders.toString()}");
  }

  String getSelectedProviderIdByServiceName(String serviceName) {
    int index = selectedProviders
        .lastIndexWhere((element) => element.serviceName == serviceName);
    print("sdjfnkja matched serviceName $serviceName dataIndex: $index");
    if (index != -1) {
      return selectedProviders[index].providerId;
    } else {
      return "";
    }
  }
}

class SelectedServiceProvider {
  String serviceName;
  String providerId;
  int serviceIndex;
  int itemIndex;

  @override
  String toString() {
    return 'SelectedServiceProvider{serviceName: $serviceName, providerId: $providerId}';
  }

  SelectedServiceProvider(
      {this.serviceName, this.providerId, this.serviceIndex, this.itemIndex});
}
