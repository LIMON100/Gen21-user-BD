import 'package:get/get.dart';

import '../../common/helper.dart';
import '../models/global_model.dart';

class GlobalService extends GetxService {
  final global = Global().obs;

  Future<GlobalService> init() async {
    var response = await Helper.getJsonFile('config/global.json');
    global.value = Global.fromJson(response);
    return this;
  }

  // this method is equivalent to commented out baseUrl methods written below
  String get baseUrl => global.value.laravelBaseUrl;

//  String get baseUrl {
//   return global.value.laravelBaseUrl;`
// }

//  String baseUrl() {
//   return global.value.laravelBaseUrl;
// }
}
