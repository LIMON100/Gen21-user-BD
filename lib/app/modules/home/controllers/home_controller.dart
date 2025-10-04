import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    // initPusher();
    super.onInit;
  }

  Future refreshHome({bool showMessage = false}) async {
    Get.find<RootController>().getNotificationsCount();
    await getSlider();
    await getCategories();
    await getFeatured();
    await getRecommendedEServices();
    Get.find<AddToCartController>().getCartList();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Future refreshHome2() async{
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      Get.showSnackbar(Ui.NormalBar(message: "Please select your current location first, before give any Order."));
    }
    await prefs.setBool('hasSeenOnboarding', false);
  }

  Address get currentAddress {
    return Get
        .find<SettingsService>()
        .address
        .value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Data not found"));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  // / Init pusher
//   Future<void> initPusher() async {
//     Pusher
//     final PusherOptions options = PusherOptions(
//       // host: "https://home-service.gen2one.co/push-test",
//       // auth: PusherAuth(
//       //   'https://home-service.gen2one.co/push-test',
//       // ),
//         encrypted: true,
//         cluster: 'mt1');
//     FlutterPusher pusher;
//     pusher = FlutterPusher('8dc6d2a858850abe4dbf', options, enableLogging: true,
//         onConnectionStateChange: (ConnectionStateChange state) async {
//           print('dkfsafs stateChange ${state.toJson()}');
//           if (pusher != null && state.currentState == 'CONNECTED') {
//             final String socketId = pusher.getSocketId();
//             print('dkfsafs pusher socket id: $socketId');
// // Laravel echo will subscribe the channel with full namespace.
//             // Ex: App\Events
//             final Echo echo = Echo(<String, dynamic>{
//               'broadcaster': 'pusher',
//               'client': pusher,
//             });
//             // echo.channel('posting').listen('PostCreated',
//             //         (Map<String, dynamic> message) {
//             //       print("dkfsafs ${message}");
//             //       // messagefinal Message msg = Message.fromJson(message);
//             //       // messages.add(msg);
//             //     });
//             echo.channel('testApp2Chennel').listen('testApp2Event',
//                     (Map<String, dynamic> message) {
//                   print("dkfsafs message: ${message}");
//                   // messagefinal Message msg = Message.fromJson(message);
//                   // messages.add(msg);
//                 });
//           }
//         });
//
//
//       var options2 = PusherOptions(
//           // host: 'https://home-service.gen2one.co/push-test',
//           // port: 6001,
//           encrypted: false,
//           cluster: 'mt1'
//       );
//
//       LaravelFlutterPusher pusher2 = LaravelFlutterPusher('c0b3904e2369b9a6ced0', options2, enableLogging: true);
//       pusher2.subscribe('testApp2Chennel')
//           .bind('testApp2Event', (event) => print('event =>' + event.toString()));
//   }
}
