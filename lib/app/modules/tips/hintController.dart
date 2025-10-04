import 'package:get/get.dart';

class HintController extends GetxController {
  RxString hintText = ''.obs;

  void setTipText(String text) {
    hintText.value = text;
  }
}
