import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/e_service_model.dart';
import '../models/favorite_model.dart';
import '../models/option_group_model.dart';
// import '../models/provider_model.dart';
import '../models/providers_model.dart';
import '../models/review_model.dart';
import '../models/search_suggestion_model.dart';
// import '../models/service_model.dart';
// import '../models/sub_service_model.dart';
import '../providers/laravel_provider.dart';

class ProviderRepository {
  LaravelApiClient _laravelApiClient;

  ProviderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Data>> searchProviders ({var data}) {
    return _laravelApiClient.searchProviders(data: data);
    // return dummyData();

  }

  // Future<SubService> getSubService () {
  //   return _laravelApiClient.getSubService();
  //
  // }


  // Future<Providers> dummyData() async {
  //   final response = await rootBundle.loadString('assets/data/providers.json');
  //   final jsonResponse = await json.decode(response);
  //   print("fsjfsads5: ${jsonResponse.toString()}");
  //   print(
  //       "fnanjdsa status: ${jsonResponse['status']} data: ${jsonResponse['data']}");
  //
  //   // if (jsonResponse['status'] == "success") {
  //   //   return Provider.fromJson(jsonResponse);
  //   // } else {
  //   //   throw new Exception(jsonResponse['message']);
  //   // }
  //
  //   try{
  //     var data = Providers.fromJson(jsonResponse);
  //
  //     print(
  //         "fnanjdsa data: ${data.toString()}");
  //
  //     return data;
  //
  //   }catch(e){
  //     print(
  //         "fnanjdsa exception: ${e.toString()}");
  //     throw new Exception(jsonResponse['message']);
  //   }
  // }




}
