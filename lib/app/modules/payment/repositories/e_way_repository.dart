import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../providers/laravel_provider.dart';

class EwayRepository {

LaravelApiClient _laravelApiClient;

EwayRepository() {
_laravelApiClient = Get.find<LaravelApiClient>();
}

Future<bool> submitEWayPaymentResult({var bodyData}) {
return _laravelApiClient.submitEWayPaymentResult(bodyData: bodyData);
}
}