import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_services/common/ui.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

import '../app/modules/book_e_service/controllers/book_e_service_controller.dart';
import '../app/modules/root/controllers/root_controller.dart';
import '../app/modules/service_request/controllers/RequestController.dart';
import '../app/services/auth_service.dart';
import '../app/services/settings_service.dart';

String get _googleMapsApiKey {
  return "AIzaSyCNfa5by9DBTfPcLdLe8vnNOlZ7pBJrN3Q";
}

void showPlacePicker() async {
  LocationResult _address = await Navigator.of(Get.context).push(
    MaterialPageRoute(
      builder: (context) => PlacePicker(Get.find<SettingsService>().setting.value.googleMapsKey, defaultLocation: LatLng(	-33.865143, 151.209900),),
    ),
  );

  // LocationResult _address = await Navigator.of(Get.context).push(
  //   MaterialPageRoute(
  //     builder: (context) => PlacePicker(_googleMapsApiKey, defaultLocation: LatLng(	-33.865143, 151.209900),),
  //   ),
  // );

  // Handle the result in your way
  print("kfsjnfjksnan ${_address.toString()} lat:${_address.formattedAddress}");
  try {
    print("kfsjnfjksnan 1");

    Get.find<SettingsService>().address.update((val) {
      // val.description = _address.description;
      val.address = _address.formattedAddress;
      val.latitude =_address.latLng.latitude;
      val.longitude = _address.latLng.longitude;
      val.userId = Get.find<AuthService>().user.value.id;
    });
    print("kfsjnfjksnan 2");

    if (Get.isRegistered<RequestController>()) {
      print("kfsjnfjksnan 3");

      await Get.find<RequestController>().getAddresses();
      print("kfsjnfjksnan 3");

      await Get.find<RequestController>().refreshRequest(showMessage: true);

      print("kfsjnfjksnan 4");

    }
    if (Get.isRegistered<BookEServiceController>()) {
      print("kfsjnfjksnan 5");

      await Get.find<BookEServiceController>().getAddresses();
      print("kfsjnfjksnan 6");

    }
    if (Get.isRegistered<RootController>()) {
      print("kfsjnfjksnan 7");
      await Get.find<RootController>().refreshPage(0);
      print("kfsjnfjksnan 8");

    }
    // isAddingLocation.value = false;
  } catch (e) {
    // isAddingLocation.value = false;
    print("kfsjnfjksnan 9");

    // Get.showSnackbar(Ui.ErrorSnackBar(message: "Something went wrong!"));
  }

  print("kfsjnfjksnan 10");

}
