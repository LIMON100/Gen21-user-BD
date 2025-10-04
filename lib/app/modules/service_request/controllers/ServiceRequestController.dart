import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/manual_order_model.dart';
import '../../../models/option_model.dart';
import '../../../models/order_request_channel.dart';
import '../../../models/order_request_model.dart';
import '../../../models/order_request_response_model.dart' as OrderRequestResponseModel;
import '../../../models/order_request_response_model.dart';
import '../../../models/order_update_pusher_event.dart';
import '../../../models/provider_model.dart' as ProvidersDataWithServiceName;
import '../../../models/provider_model.dart' as SingleProvider;
import '../../../models/providers_model.dart';
import '../../../models/requested_service_model.dart';
import '../../../providers/database_helper.dart';
import '../../../providers/laravel_provider.dart';
import '../../../repositories/cart_repository.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/notification_repository.dart';
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
import '../../root/controllers/root_controller.dart';
import '../widgets/bottomsheet_widget.dart';
import '../widgets/welcome_widget_test.dart';
import '../../../models/notification_model.dart';

class ServiceRequestController extends GetxController {
  ProviderRepository _providerRepository;
  RequestRepository _requestRepository;

  SettingRepository _settingRepository;
  var bookingAt = DateTime.now().obs;
  // var isLoading = false.obs;

  // var addToCartData = List<AddToCart>().obs;

  // var orderTimeType = ["As soon as possible", "Schedule a time"].obs;
  List<DropdownMenuItem<String>> orderTimeType = [
    DropdownMenuItem(child: Text("As Soon As Possible"), value: "As Soon As Possible"),
    DropdownMenuItem(child: Text("Schedule An Order"), value: "Schedule An Order"),
  ];

  List<DropdownMenuItem<String>> orderRequestType = [
    DropdownMenuItem(child: Text("Request To System"), value: "Request To System"),
    DropdownMenuItem(child: Text("Choose Provider Manually"), value: "Choose Provider Manually"),
  ];

  // TIMER
  Timer timer;
  Timer _timer;
  int remainingSeconds =1;
  final time = '00.00'.obs;

  // var time = "".obs;
  // var date = "".obs;
  // var selectedOrderTimeType = "".obs;
  // var selectedOrderRequestType = "".obs;

  // var providersData = <Data>[].obs;
  // var providersDataWithServiceName = <ProvidersDataWithServiceName.Data>[].obs;

  // TextEditingController noteEditingController, couponEditingController;
  TextEditingController couponEditingController;

  // var orderRequestResponse = OrderRequestResponseModel.OrderRequestResponse().obs;

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  var pusherChannelSubscriptionStatus = "".obs;

  // Address get currentAddress => Get.find<SettingsService>().address.value;

  // var addToCartObs =  AddToCart().obs;

  final AddToCartController _addToCartController = Get.put(AddToCartController());

  // var coupon = Coupon().obs;

  var isLoading = false.obs;

  var orderRequestResponse = OrderRequestResponseModel.OrderRequestResponse().obs;

  // var orderedServiceList = <OrderRequestResponseModel.Service>[].obs;

  // var serviceRequestString = "".obs;
  // var serviceRequestResponse;


  ServiceRequestController() {
    // _providerRepository = new ProviderRepository();
    _requestRepository = new RequestRepository();
    // _settingRepository = SettingRepository();
    // noteEditingController = new TextEditingController();
    // couponEditingController = new TextEditingController();
  }

  // @override
  // Future<void> onInit() async {
  //   this.selectedOrderTimeType.value = orderTimeType[0].value;
  //   this.selectedOrderRequestType.value = orderRequestType[0].value;
  //   super.onInit();
  // }

  int bookID = 0;
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();
  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    print("KYToitojuu argmnts ServiceController ${arguments.toString()}");
    orderRequestResponse.value = arguments['service_requests'] as OrderRequestResponse;

    pusherInit();
    // connectToPusher(serviceRequestString.value);
    connectToPusher(orderRequestResponse.value);
    // tryNotification();
    super.onInit();
  }


  // Notification
  Future<void> fetchNotifications() async {
    try {
      bookID = await _laravelApiClient.getNotificationsForID();
      print("AJKERDEALKORLAM");
      print(bookID);
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }


  reInit(OrderRequestResponse response){
    orderRequestResponse.value = response;

    pusherInit();
    // connectToPusher(serviceRequestString.value);
    connectToPusher(orderRequestResponse.value);
  }

  @override
  void onReady() async {
    print("fsjfsads0");
    await refreshEService();
    // _startTimer(20);
    // startTimer2();
    super.onReady();
  }

  @override
  void onClose(){
    if(_timer!=null){
      _timer.cancel();
    }
  }

  Future startTimer2() {
    int seconds = 20;
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;

    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        int hours = remainingSeconds ~/ 3600;
        int minutes = (remainingSeconds % 3600) ~/ 60;
        int seconds = remainingSeconds % 60;

        // time.value = "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        time.value = "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainingSeconds--;
      }
    });
  }

  // _startTimer(int seconds) {
  //   const duration = Duration(seconds: 1);
  //   remainingSeconds = seconds;
  //
  //   _timer = Timer.periodic(duration, (Timer timer) {
  //     if (remainingSeconds == 0) {
  //       timer.cancel();
  //     } else {
  //       int hours = remainingSeconds ~/ 3600;
  //       int minutes = (remainingSeconds % 3600) ~/ 60;
  //       int seconds = remainingSeconds % 60;
  //
  //       // time.value = "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  //       time.value = "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  //       remainingSeconds--;
  //     }
  //   });
  // }


  Future refreshEService({bool showMessage = false}) async {
    print("fsjfsads1");

    // getService("1");

    // searchProviders();
    if (showMessage) {
      // Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }


  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }


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
      print("skfjdsann error1: $e");
    }
  }

  void onEvent(PusherEvent event) {
    printWrapped("jfsdbakhfda ServiceRequestController onEvent: $event");
    handleOnEventData(event);

  }

  void handleOnEventData(PusherEvent event) async{

    OrderUpdatePusherEvent pusherEvents = OrderUpdatePusherEvent.fromJson(jsonDecode(event.data));
    // print("jnfabhkio id: ${authService.userId}");
    // print("jnfabhkio apiToken: ${authService.apiToken}");
    printWrapped("jfsdbakhfda ServiceRequestController pusherEvents: ${pusherEvents.toString()}");


    pusherEvents.eventData.forEach((pusherEvent) {
      print("jfsdbakhfda in 1");
      if (pusherEvent.status.toString() == "accept") {
        // orderRequestResponse.value.eventData.service.forEach((requestEvent) {
        //   if (requestEvent.serviceType == pusherEvent.serviceType && requestEvent.eServiceId == pusherEvent.eServiceId) {
        //     print("jnfabhkio  ${pusherEvent.eServiceName} has been accepted");
        //     Get.back();
        //     if (Get.currentRoute == Routes.ROOT) {
        //       print("jnfabhkio  Routes.ROOT");
        //       Get.find<RootController>().currentIndex.value = 1;
        //     }
        //
        //     Get.snackbar("${pusherEvent.eServiceName} has been accepted", "See details");
        //   }
        // });
        changeBookingStatusToAccept("${pusherEvent.eServiceId}", "${pusherEvent.serviceType}");
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

  // connectToPusher() async {
  //   print("kwnnasf connectToPusher called");
  //   if (pusher.connectionState.capitalize == "CONNECTED") {
  //     await pusher.subscribe(channelName: "${orderRequestResponse.value.channelName}");
  //     await pusher.connect();
  //   } else {
  //     print("skfjdsann not connected: ${pusher.connectionState.toString()}");
  //     await pusher.subscribe(channelName: "${orderRequestResponse.value.channelName}");
  //     await pusher.connect();
  //   }
  // }

  connectToPusher(OrderRequestResponse orderRequestResponse) async {
    print("jdfafjdsfsd connectToPusher called");
    // OrderRequestResponse orderRequestResponse = OrderRequestResponse.fromJson(jsonDecode(pushBody));
    print("jdfafjdsfsd adding orderRequestPush: ${orderRequestResponse.toString()}");
    // this.orderRequestPush.value = orderRequestPush;
    // this.orderedServiceList.value = orderRequestResponse.eventData.service;
    // print("jdfafjdsfsd getting orderRequestPush: ${this.orderedServiceList.value.toString()}");
    if (pusher.connectionState.capitalize == "CONNECTED") {
      print("fhsahdsa in 1");
      await pusher.subscribe(channelName: "${orderRequestResponse.channelName}");
      await pusher.connect();
    } else {
      print("fhsahdsa in 2");
      print("skfjdsann not connected: ${pusher.connectionState.toString()}");
      await pusher.subscribe(channelName: "${orderRequestResponse.channelName}");
      await pusher.connect();
    }

    // Get.bottomSheet(
    //     TestBottomSheetWidget()
    // );
    // print("jdfafjdsfsd redirecting to jdfafjdsfsd()");

    // Get.to(TestView());
  }

  changeBookingStatusToAccept(String serviceId, String serviceType) {
    int index = orderRequestResponse.value.eventData.service.indexWhere((element) => element.eServiceId == serviceId && element.serviceType == serviceType);
    // orderedServiceList.removeAt(index);
    printWrapped("jfsdbakhfda index: $index data before changed ${orderRequestResponse.toString()}");
    // orderRequestResponse.value.eventData.service.elementAt(index).status = "received";
    orderRequestResponse.update((val) {
      val.eventData.service.elementAt(index).status = "received";
    });

    printWrapped("jfsdbakhfda index: $index data after changed1: ${orderRequestResponse.toString()}");
    update();
    printWrapped("jfsdbakhfda index: $index data after changed2: ${orderRequestResponse.toString()}");
  }

  // Future<OrderRequestResponseModel.OrderRequestResponse> resendOrder() async {
  //   pusherChannelSubscriptionStatus.value = "";
  //   try {
  //     // print("jdsnakkb currentAddress: ${currentAddress.toString()}");
  //     // var jsonObjList = List<dynamic>();
  //     // data.forEach((element) {
  //     //   jsonObjList.add(element.toJson());
  //     // });
  //     // print("jsnfnanj cart dataaa: ${data.toString()}");
  //
  //     printWrapped("flasjhdjfa lastOrderRequestResponse: ${orderRequestResponse.toString()}");
  //     List<RequestedService> reqData = [];
  //     printWrapped("flasjhdjfa orderRequestResponse.value.eventData.service.length: $orderRequestResponse.value.eventData.service.length}");
  //     for (int i = 0; i < orderRequestResponse.value.eventData.service.length; i++) {
  //       printWrapped("flasjhdjfa in loop: $i");
  //
  //       Service service = orderRequestResponse.value.eventData.service[i];
  //       if (service.status == null) {
  //         printWrapped("flasjhdjfa in loop: if");
  //         reqData.add(RequestedService(id: int.parse(service.id), type: service.serviceType, service_name: service.serviceName, service_id: service.eServiceId, name: service.name, image_url: service.imageUrl, price: service.price, minimum_unit: service.minimumUnit, added_unit: service.addedUnit, booking_at: service.bookingAt.toUtc().toString()));
  //       }
  //     }
  //     printWrapped("flasjhdjfa reSending Data: ${json.encode(reqData)}");
  //     OrderRequest orderRequest = new OrderRequest(orderRequestResponse.value.eventData.couponData != null?  "test" : "", noteEditingController.text, orderRequestResponse.value.eventData.address, reqData);
  //     printWrapped("flasjhdjfa resendingOrderRequest Data in user APP:${json.encode(orderRequest)}");
  //
  //     // _requestRepository.submitBookingRequest(data: json.encode(orderRequest)).then((value) {
  //     //   orderRequestResponse.value = value;
  //     //   Get.toNamed(Routes.SERVICE_REQUESTS, arguments: {"service_requests": orderRequestResponse.value});
  //     // });
  //     // Get.toNamed(Routes.SERVICE_REQUEST, arguments: {"pending_requests": });
  //   } catch (e) {
  //     pusherChannelSubscriptionStatus.value = "error";
  //     orderRequestResponse.value = null;
  //     print("jsnfnanj e: ${e.toString()}");
  //   }
  // }


  Future<OrderRequestResponseModel.OrderRequestResponse> resendRequest(){
    // reInit();
  }

  cancelOrder(String orderId) async{
    try {
      print("ORDERIDDD");
      print(orderId);
      isLoading.value = true;
      await _requestRepository.cancelOrder(orderId);
      isLoading.value = false;
      Get.back();
    }catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong".tr));
    }
  }

}
