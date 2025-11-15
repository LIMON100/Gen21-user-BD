import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:namefully/namefully.dart';

import '../../../../common/log_data.dart';
import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/message_model.dart';
import '../../../models/providers_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../global_widgets/otp_input_dialog.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../tips/tip_controller.dart';
import '../data/body/e_way_initiate_body.dart';
import '../data/responses/eway_initeate_sesponse.dart' as eWayInitiateResponseRef;
import 'bookings_controllerNew.dart';

class BookingControllerNew extends GetxController {
  EProviderRepository _eProviderRepository;
  BookingRepository _bookingRepository;
  final allMarkers = <Marker>[].obs;
  final bookingStatuses = <BookingStatus>[].obs;
  Timer timer;
  GoogleMapController mapController;
  final booking = BookingNew().obs;

  // BookingRepository _bookingsRepository;
  var initiatingEway = false.obs;
  UserRepository _userRepository;
  var user = new User().obs;

  var loadingStartChat = false.obs;
  var isLoading = false.obs;

  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();

  BookingControllerNew() {
    print("jsdnjfnsa constructor()");
    _bookingRepository = BookingRepository();
    _eProviderRepository = EProviderRepository();
    // _bookingsRepository = new BookingRepository();
    _userRepository = new UserRepository();
  }

  // TImer for countdown
  Timer _timer;
  int remainingSeconds =1;
  final time = '00.00'.obs;

  @override
  void onInit() async {
    print("jsdnjfnsa onInit()");
    // booking.value = Get.arguments as Booking;
    await getBookingStatuses();
    booking.value = Get.arguments as BookingNew;
    super.onInit();
  }


  @override
  void onReady() async {
    print("jsdnjfnsa onReady()");
    await refreshBooking();
    _startTimer(900);
    super.onReady();
  }

  @override
  void onClose(){
    if(_timer!=null){
      _timer.cancel();
    }
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;

    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        int hours = remainingSeconds ~/ 3600;
        int minutes = (remainingSeconds % 3600) ~/ 60;
        int seconds = remainingSeconds % 60;

        time.value = "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";

        remainingSeconds--;
      }
    });
  }


  Future refreshBooking({bool showMessage = false, bool showProgressView = false}) async {
    print("jsdnjfnsa refreshBooking()");
    isLoading.value = showProgressView;
    await getBooking();
    initBookingAddress();
    await getUser();
    isLoading.value = false;
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking page refreshed successfully".tr));
    }
  }

  Future<void> getBooking() async {
    // try {
    booking.value = await _bookingRepository.getBookingDetails(booking.value.id);
    // if (booking.value.status == Get.find<BookingsControllerNew>().getStatusByOrder(Get.find<GlobalService>().global.value.inProgress) && timer == null) {
    if (booking.value.status == getStatusByOrder(Get.find<GlobalService>().global.value.inProgress) && timer == null) {
      timer = Timer.periodic(Duration(minutes: 1), (t) {
        booking.update((val) {
          val.duration += (1 / 60);
        });
      });
    }
    // } catch (e) {
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  Future<void> startBookingService() async {
    try {
      final _status = Get.find<BookingsControllerNew>().getStatusByOrder(Get.find<GlobalService>().global.value.inProgress);
      // final _status = Get.find<GlobalService>().global.value.inProgress;
      _status.id = '2';
      _status.status = 'In Progress';
      _status.order = 40;
      final _booking = new Booking(id: booking.value.id, startAt: DateTime.now(), status: _status as BookingStatus);
      // Wait for the updateBookingNew operation to complete
      await _bookingRepository.updateBookingNew(_booking);
      print("After await");

      // Update local state after the await operation is complete
      booking.update((val) {
        val.startAt = _booking.startAt;
        val.status = _status as BookingStatus;
      });

      // Set up a periodic timer after the await operation is complete
      timer = Timer.periodic(Duration(minutes: 1), (t) {
        booking.update((val) {
          val.duration += (1 / 60);
        });
      });
    }
    catch (e) {
    }
  }

  Future<void> cancelBookingService() async {
    try {
      if (booking.value.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = Get.find<BookingsControllerNew>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking = new Booking(id: booking.value.id, cancel: true, status: _status);
        await _bookingRepository.updateBookingNew(_booking);
        booking.update((val) {
          val.cancel = true;
          val.status = _status;
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> cancelBookingServiceNew() async {
    try {
      if (booking.value.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = Get.find<BookingsControllerNew>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        _status.id = '7';
        _status.status = 'Canceled';
        _status.order = 60;
        final _booking = new Booking(id: booking.value.id, cancel: true, status: _status);
        await _bookingRepository.updateBookingNew(_booking);
        booking.update((val) {
          val.cancel = true;
          val.status = _status;
          val.booking_status_id = "7";
        });
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

  String getTime({String separator = ":"}) {
    String hours = "";
    String minutes = "";
    int minutesInt = ((booking.value.duration - booking.value.duration.toInt()) * 60).toInt();
    int hoursInt = booking.value.duration.toInt();
    if (hoursInt < 10) {
      hours = "0" + hoursInt.toString();
    } else {
      hours = hoursInt.toString();
    }
    if (minutesInt < 10) {
      minutes = "0" + minutesInt.toString();
    } else {
      minutes = minutesInt.toString();
    }
    return hours + separator + minutes;
  }

  Future<void> startChat() async {
    loadingStartChat.value = true;
    try {
      // print("fndjknakjfndjs startChat() called ooking.value.acceptor_provider_id: ${booking.value.acceptor_provider_id}");

      List<User> _employees = await _eProviderRepository.getUsersByUserId(booking.value.acceptor_provider_id);
     printWrapped("fndjknakjfndjs ${_employees.toString()}");
      _employees = _employees
          .map((e) {
        e.avatar = booking.value.eProvider.images[0];
        return e;
      })
          .toSet()
          .toList();

      if(_employees.length> 0 ) {
        Get.find<MessagesController>().getUserAndProviderMessageId(_employees[0].id).then((value) {
          List<Message> messages = value;
          print("sndnfdsnjsd messages: ${messages.toString()}");
          Message _message;
          if (messages.length > 0) {
            print("fndjknakjfndjs 1");
            _message = new Message(_employees, id: messages[0].id, name: booking.value.eProvider.name);
          } else {
            print("fndjknakjfndjs 2");
            _message = new Message(_employees, name: booking.value.eProvider.name);
          }

          // print("fndjknakjfndjs _message: ${_message.toString()}");
          print("sndnfdsnjsd chats: ${Get
              .find<MessagesController>()
              .chats}");
          Get
              .find<MessagesController>()
              .chats
              .clear();
          print("sndnfdsnjsd chats now: ${Get
              .find<MessagesController>()
              .chats}");

          print("sndnfdsnjsd _message: ${_message.toString()}");
          // Message _message = new Message(_employees, name: booking.value.eProvider.name);
          Get.toNamed(Routes.CHAT, arguments: _message);
        });
      }else{
        Message _message = new Message(_employees, name: booking.value.eProvider.name);
        Get.toNamed(Routes.CHAT, arguments: _message);
      }
    }catch (e){
      printWrapped("fsnfnafsnfs ${e.toString()}");
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong"));
    }
    loadingStartChat.value = false;
  }

  BookingStatus getStatusByOrder(int order) => bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Booking status found".tr));
        return BookingStatus();
      });

  Future getBookingStatuses() async {
    // print("hsbjkakjsj getBookingStatuses() called ${orderId} ");
    try {
      bookingStatuses.assignAll(await _bookingRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> initiateEway(BookingNew bookingNew) async {
    try {
      Namefully name;
      if (user.value.name != null && user.value.name.contains(" ")) {
        name = Namefully('${user.value.name}', config: Config.inline(separator: Separator.space, bypass: false));
      } else {
        name = Namefully('${user.value.name} ${user.value.name}');
      }

      initiatingEway.value = true;
      Customer customer = Customer(reference: "", title: "", firstName: '${name.first}', lastName: '${name.last}', companyName: "", jobDescription: "", street1: "${user.value.address}", street2: "", city: "", state: "", postalCode: "", country: "Au", mobile: "", phone: "${user.value.phoneNumber}", email: "${user.value.email}");
      ShippingAddress shippingAddress = ShippingAddress(shippingMethod: "", firstName: "", lastName: "", street1: "", street2: "", city: "", state: "", country: "", postalCode: "", phone: "");
      Payment payment = Payment(totalAmount: booking.value.total_payable_amount * 100 , invoiceNumber: booking.value.id, invoiceDescription: "${booking.value.user.name} ${booking.value.user.email} ${booking.value.user.phoneNumber}", invoiceReference: "", currencyCode: "AUD");
      // Payment payment = Payment(totalAmount: ((booking.value.total_payable_amount + 5)) * 100, invoiceNumber: booking.value.id, invoiceDescription: "${booking.value.user.name} ${booking.value.user.email} ${booking.value.user.phoneNumber}", invoiceReference: "", currencyCode: "AUD");
      EwayInitiateBody ewayInitiateBody = EwayInitiateBody(customer: customer, shippingAddress: shippingAddress, payment: payment, redirectUrl: "http://www.eway.com.au", cancelUrl: "https://app.gen21.com.au/login", method: "ProcessPayment", deviceID: "", customerIP: "", partnerID: "", transactionType: "Purchase", logoUrl: "https://i.ibb.co/1Qdgjvk/gen21-png.png", headerText: "Gen21 Payment", language: "EN", customerReadOnly: true, customView: "bootstrap", verifyCustomerPhone: false, verifyCustomerEmail: false);
      eWayInitiateResponseRef.EwayInitiateResponse ewayInitiateResponse = await _bookingRepository.initiateEway(ewayInitiateBody);

      print("jdfnjsafsn ${booking.value}");

      if (ewayInitiateResponse.errors == null) {
        Get.toNamed(Routes.E_WAY, arguments: {'ewayInitiateResponse': ewayInitiateResponse, 'booking': booking.value});
      }
      initiatingEway.value = false;
    } catch (e) {
      initiatingEway.value = false;
      print("shfdsnfdsk e:${e.toString()}");
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }



  // NEW: This is the main function that will be called from the UI
  // Future<void> promptForOtpAndFinishBooking() async {
  //   try {
  //     isLoading.value = true; // Show a loading indicator
  //     // Step 1: Call API-1 to send the OTP to the user
  //     bool otpSent = await _bookingRepository.sendBookingOtp(booking.value.id);
  //
  //     if (otpSent) {
  //       // Step 2: If OTP was sent successfully, show the dialog
  //       _showOtpDialog();
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: "Failed to send OTP for confirmation"));
  //   } finally {
  //     isLoading.value = false; // Hide loading indicator
  //   }
  // }

  Future<void> finishBookingService() async {
    try {
      final _status = Get.find<BookingsControllerNew>().getStatusByOrder(Get.find<GlobalService>().global.value.done);
      var _booking = new Booking(id: booking.value.id, endsAt: DateTime.now(), status: _status);
      print("jsnfjsansdkll booking: ${_booking.toString()}");

      final result = await _bookingRepository.updateBookingNew(_booking);
      print("jsnfjsansdkll result: ${result.toString()}");

      booking.update((val) {
        val.endsAt = result.endsAt;
        val.duration = result.duration;
        val.status = _status;
      });
      timer?.cancel();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> promptForOtpAndFinishBooking() async {
    try {
      isLoading.value = true; // Show a loading indicator
      // Step 1: Attempt to call API-1 to send the OTP to the user.
      // We will not wait for the 'otpSent' boolean result to decide the next step.
      await _bookingRepository.sendBookingOtp(booking.value.id);

    } catch (e) {
      // If the API call fails, show an informative snackbar but continue to the dialog.
      // The user might have a pre-shared OTP or this could be for a test environment.
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Could not send OTP. You can still enter a valid code.".tr));
      print("Error sending OTP, but proceeding to dialog anyway: $e");
    } finally {
      // No matter what happens (success or failure of OTP sending),
      // we proceed to show the dialog and hide the loading indicator.
      isLoading.value = false; // Hide loading indicator
      _showOtpDialog(); // Step 2: Always show the OTP dialog
    }
  }

// NEW: Private helper method to show the OTP dialog
  void _showOtpDialog() {
    final TextEditingController otpController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("Enter OTP".tr),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter the OTP you received".tr,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel".tr),
          ),
          TextButton(
            onPressed: () {
              String otpCode = otpController.text.trim();
              if (otpCode.isNotEmpty) {
                Get.back(); // Close the dialog
                // Step 3: Call the final function with the entered OTP
                finishBookingServiceWithOtp(otpCode);
              } else {
                Get.showSnackbar(Ui.ErrorSnackBar(message: "Please enter the OTP".tr));
              }
            },
            child: Text("Confirm".tr),
          ),
        ],
      ),
    );
  }


// NEW: This function calls the modified API-2 with the OTP
  Future<void> finishBookingServiceWithOtp(String otpCode) async {
    try {
      isLoading.value = true;
      final _status = Get.find<BookingsControllerNew>().getStatusByOrder(Get.find<GlobalService>().global.value.done);
      var _booking = new Booking(id: booking.value.id, endsAt: DateTime.now(), status: _status);

      // Call the new repository method that includes the OTP
      final result = await _bookingRepository.updateBookingStatusWithOtp(_booking, otpCode);

      booking.update((val) {
        val.endsAt = result.endsAt;
        val.duration = result.duration;
        val.status = _status;
      });
      timer?.cancel();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Booking finished successfully!".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
