import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import '../../common/log_data.dart';
import '../../common/ui.dart';
import '../models/booking_model.dart';
import '../models/booking_new_model.dart';
import '../models/message_model.dart';
import '../modules/bookings/controllers/booking_controller.dart';
import '../modules/bookings/controllers/booking_controller_new.dart';
import '../modules/bookings/controllers/bookings_controller.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    printWrapped("ksdfksan 1");
    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true);
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    printWrapped("ksdfksan 2");

    return this;
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // printWrapFped("jsdnjfnsa user app fcmOnMessageListeners() 3");

      printWrapped("jsdnjfnsa user app 0 fcmOnMessageListeners() ${message.notification.body}");
      FlutterRingtonePlayer.playNotification();
      if (Get.isRegistered<RootController>()) {
        Get.find<RootController>().getNotificationsCount();
      }
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _bookingNotification(message);
      }
    });
  }

  Future fcmOnLaunchListeners() async {
    printWrapped("jsdnjfnsa user app 1 fcmOnLaunchListeners()");
    RemoteMessage message = await FirebaseMessaging.instance.getInitialMessage();
    printWrapped("ksdmflnsaue user app fcmOnLaunchListeners() 5");
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future fcmOnResumeListeners() async {
    printWrapped("jsdnjfnsa user app 2 fcmOnResumeListeners()");

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    printWrapped("jsdnjfnsa user app _notificationsBackground()  message 6");
    printWrapped("ksdmflnsaue user app _notificationsBackground()  message ${message.notification.body}");
    printWrapped("ksdmflnsaue user app _notificationsBackground()  data ${message.data.toString()}");

    if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    } else {
      _newBookingNotificationBackground(message);
    }
  }

  void _newBookingNotificationBackground(message) {
    if (Get.currentRoute == Routes.BOOKING_DETAILS) {
      print("jsdnjfnsa user app 3 _bookingNotification()");
      Get.find<BookingControllerNew>().refreshBooking(showProgressView: true);
    }
    else if (Get.isRegistered<RootController>()) {
      print("jsdnjfnsa user app _newBookingNotificationBackground() data: ${message.data['bookingId']}");
      Get.toNamed(Routes.BOOKING_DETAILS, arguments: new BookingNew(id: message.data['bookingId']));
    }



  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    if (message.data['messageId'] != null) {
      Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
    }
  }

  Future<void> setDeviceToken() async {
    Get.find<AuthService>().user.value.deviceToken = await FirebaseMessaging.instance.getToken();
  }

  void _bookingNotification(RemoteMessage message) {
    print("jsdnjfnsa user app 2  _bookingNotification()");
    if (Get.currentRoute == Routes.ROOT) {
      Get.find<BookingsController>().refreshBookings();
    }
    if (Get.currentRoute == Routes.BOOKING_DETAILS) {
      print("jsdnjfnsa user app 3 _bookingNotification()");
      Get.find<BookingControllerNew>().refreshBooking(showProgressView: true);
    }
    if (Get.find<MessagesController>().initialized) {
      print("sdbfhbahsmessage Get.find<MessagesController>().initialized");
      Get.find<MessagesController>().refreshMessages(showProgressView: true);
    } else{
      print("sdbfhbahsmessage Get.find<MessagesController>() not initialized");
    }
    // if (Get.currentRoute == Routes.BOOKING) {
    //   Get.find<BookingControllerNew>().refreshBooking();
    // }
    RemoteNotification notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification.title,
      message: notification.body,
      mainButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: message.data != null ? message.data['icon'] : "",
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
        ),
      ),
      onTap: (getBar) async {
        if (message.data['bookingId'] != null) {
          await Get.back();
          // Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
          // Get.toNamed(Routes.BOOKING_DETAILS, arguments: new Booking(id: message.data['bookingId']));
        }
      },
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    print("sdbfhbahsmessage _newMessageNotification()");
    RemoteNotification notification = message.notification;
    if (Get.find<MessagesController>().initialized) {
      print("sdbfhbahsmessage Get.find<MessagesController>().initialized");
      Get.find<MessagesController>().refreshMessages(showProgressView: true);
    } else{
      print("sdbfhbahsmessage Get.find<MessagesController>() not initialized");
    }

    // if (Get.currentRoute == Routes.ROOT) {
    //   Get.find<BookingsController>().refreshBookings();
    // }

    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title,
        message: notification.body,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null ? message.data['icon'] : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
            await Get.back();
            Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
          }
        },
      ));
    }
  }


}
