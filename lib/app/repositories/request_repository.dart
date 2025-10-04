import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/coupon_model.dart';
import '../models/e_service_model.dart';
import '../models/favorite_model.dart';
import '../models/option_group_model.dart';
import '../models/order_request_channel.dart';
import '../models/order_request_reponse_model_booking_id.dart';
import '../models/order_request_response_model.dart';
import '../models/provider_model.dart';
import '../models/review_model.dart';
import '../models/search_suggestion_model.dart';
import '../models/service_model.dart';
import '../models/sub_service_model.dart';
import '../providers/laravel_provider.dart';

class RequestRepository {
  LaravelApiClient _laravelApiClient;

  RequestRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }


  Future<OrderRequestResponse> submitBookingRequest({var data}) {
    return _laravelApiClient.submitBookingRequest(data: data);
  }

  Future<Map<String, dynamic>>  submitBookingRequest2({var data}) {
    return _laravelApiClient.submitBookingRequest2(data: data);
  }

  Future<bool> submitManualBookingRequest({var data}) {
    return _laravelApiClient.submitManualBookingRequest(data: data);
  }

  Future<Coupon> validateCouponByCode(String code) {
    return _laravelApiClient.validateCouponByCode(code);
  }

  Future<bool> cancelOrder(String orderId) {
    return _laravelApiClient.cancelOrder(orderId);
  }

}
