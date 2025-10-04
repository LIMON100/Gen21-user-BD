import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/coupon_model.dart';
import '../models/e_service_model.dart';
import '../models/favorite_model.dart';
import '../models/option_group_model.dart';
import '../models/review_model.dart';
import '../models/search_suggestion_model.dart';
import '../models/service_details_model.dart';
import '../models/service_model.dart';
import '../models/sub_service_model.dart';
import '../providers/laravel_provider.dart';

class ServiceRepository {
  LaravelApiClient _laravelApiClient;

  ServiceRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Coupon>> tryCoupon() async {
    print("couponrepos");
    return _laravelApiClient.fetchCoupons();
  }

  Future<GService> get  (String id) {
    return _laravelApiClient.getService(id);
  }

  Future<SubService> getSubService  (String id) {
    return _laravelApiClient.getSubService(id);

  }

  Future<ServiceDetails> getServiceDetails  (String id) {
    return _laravelApiClient.getServiceDetails(id);

  }


  Future<GService> dummyData() async {
    final response = await rootBundle.loadString('assets/data/service2.json');
    final jsonResponse = await json.decode(response);
    print("fsjfsads5: ${jsonResponse.toString()}");
    print(
        "fsjfsads6 status: ${jsonResponse['status']} data: ${jsonResponse['data']}");

    if (jsonResponse['status'] == "success") {
      return GService.fromJson(jsonResponse);
    } else {
      throw new Exception(jsonResponse['message']);
    }
  }
}
