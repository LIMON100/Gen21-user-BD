import 'package:get/get.dart';

class TipController extends GetxController {
  RxString tipText = ''.obs;

  void setTipText(String text) {
    tipText.value = text;
  }
}
