import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'app/modules/global_widgets/no_internet_connection.dart';
import 'app/modules/onboard/OnboardingScreen.dart';
import 'app/modules/service_request/controllers/RequestController.dart';
import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
import 'common/log_data.dart';
import 'get_server_key.dart';

void initServices() async {

  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => TranslationService().init());
  await Get.putAsync(() => GlobalService().init());
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());

  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  Get.log('All services started...');

  try {
    bool _permissionPrompted = false;
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    // printWrapped("gen21 6766 messaging.getAPNSToken() ${await messaging.getAPNSToken()} essaging.getToken:${await messaging.getToken()}");
    // printWrapped("gen21 6766 token:${await messaging.getToken()}");

    if (!_permissionPrompted) {
      // if (messaging.authorizationStatus != AuthorizationStatus.authorized) {
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: false,
      );
      // }

      _permissionPrompted = true;
    }

  }catch(e){
    Get.log('gen21 log push notification permission error ...${e.toString()}');
  }


}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // RemoteNotification notification = message.notification;

  // FireBaseMessagingService().fcmOnMessageListeners();
  FlutterRingtonePlayer.playNotification();

  print("gen_log dsjnjksnkj");

}


void main() async {
  // print("HERE FIRST,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
  // GetServerKey getServerKey = GetServerKey();
  // String accessToken = await getServerKey.getServerKeyToken();
  // print(accessToken);

  WidgetsFlutterBinding.ensureInitialized();

  // await GetStorage.init();

  bool isInternetConnected = await InternetConnectionChecker().hasConnection;
  print("fklkaslkld $isInternetConnected");


  if (isInternetConnected) {
    await initServices();
    print("fklkaslkld 1");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  } else {
    print("fklkaslkld 2");
  }

  Get.put(RequestController());
  runApp(
    isInternetConnected
        ? GetMaterialApp(
            title: Get.find<SettingsService>().setting.value.appName,
            initialRoute: Theme1AppPages.INITIAL,
            onReady: () async {
              print("fklkaslkld 3");
              await Get.putAsync(() => FireBaseMessagingService().init());
            },
            getPages: Theme1AppPages.routes,
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: Get.find<TranslationService>().supportedLocales(),
            translationsKeys: Get.find<TranslationService>().translations,
            locale: Get.find<SettingsService>().getLocale(),
            fallbackLocale: Get.find<TranslationService>().fallbackLocale,
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.cupertino,
            themeMode: Get.find<SettingsService>().getThemeMode(),
            theme: Get.find<SettingsService>().getLightTheme(),
            darkTheme: Get.find<SettingsService>().getDarkTheme(),
          )
        : GetMaterialApp(
            title: "No Internet Connection",
            initialRoute: Theme1AppPages.NO_INTERNET,
            getPages: Theme1AppPages.routes,
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.cupertino,
          ),
  );
}
