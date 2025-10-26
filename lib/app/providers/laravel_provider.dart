import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:home_services/app/models/orders_model.dart' as OrderModel;
import '../../common/constant.dart';
import '../../common/log_data.dart';
import '../../common/uuid.dart';
import '../models/add_to_cart_model.dart';
import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_new_model.dart' as BookingModelNew;
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/coupon_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_provider_model.dart' as provider;
import '../models/e_provider_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/favorite_model.dart';
import '../models/gallery_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/order_request_channel.dart';
import '../models/order_request_model.dart';
import '../models/order_request_reponse_model_booking_id.dart';
import '../models/order_request_response_model.dart' as OrderRequestResponseModel;
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/providers_model.dart' as ProvidersData;
import '../models/review_model.dart';
import '../models/search_suggestion_model.dart';
import '../models/service_details_model.dart' as ServiceDetails;
import '../models/service_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../models/sub_service_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../modules/bookings/data/responses/eway_initeate_sesponse.dart' as eWayInitiateResponseRef;
import '../services/settings_service.dart';
import 'api_provider.dart';
import 'package:http/http.dart' as http;

import '../models/order_request_reponse_model_booking_id.dart' as OrderRequestResponseModelBookingId;

class LaravelApiClient extends GetxService with ApiClient {
  dio.Dio _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;
  List<Coupon> coupons = [];
  int valueForResponse = 0;
  int valueForOrderId = 0;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = new dio.Dio();
    // _httpClient.options.headers['content-Type'] = 'application/json';
  }

  Future<LaravelApiClient> init() async {
    if (foundation.kIsWeb || foundation.kDebugMode) {
      _optionsNetwork = dio.Options();
      _optionsCache = dio.Options();
    } else {
      _optionsNetwork = buildCacheOptions(Duration(days: 3), forceRefresh: true);
      _optionsCache = buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
      _httpClient.interceptors.add(DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    }

    return this;
  }

  Future<String> fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://app.gen21.com.au/api/user?api_token=${authService.apiToken}&version=2'),
    );
    if (response.statusCode == 200) {
      var _responseData = response.body;
      return _responseData;
    }
    else {
      throw Exception('Failed to load data');
    }
  }


  // COUPONS
  Future<List<Coupon>> fetchCoupons() async {
    // final response = await http.get(Uri.parse('https://app.gen21.com.au/api/coupon-list?api_token=${authService.apiToken}'));
    final response = await http.get(Uri.parse('https://app.gen21.com.au/api/coupon-list?api_token=${authService.apiToken}&version=2'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        final List<dynamic> couponList = jsonResponse['data'];
        List<Coupon> coupons = couponList.map((data) => Coupon.fromJson(data)).toList();
        return coupons;
      } else {
        // Handle error
        print("Failed to fetch coupons: ${jsonResponse['message']}");
        return [];
      }
    } else {
      // Handle error
      print("Failed to fetch coupons: ${response.reasonPhrase}");
      return [];
    }
  }

  // Get Service Charge
  Future<List<Coupon>> getServiceCharge() async {
    // final response = await http.get(Uri.parse('https://app.gen21.com.au/api/settings'));
    final response = await http.get(Uri.parse('https://app.gen21.com.au/api/settings&version=2'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        final List<dynamic> couponList = jsonResponse['data'];
        List<Coupon> coupons = couponList.map((data) => Coupon.fromJson(data)).toList();
        return coupons;
      } else {
        // Handle error
        print("Failed to fetch coupons: ${jsonResponse['message']}");
        return [];
      }
    } else {
      // Handle error
      print("Failed to fetch coupons: ${response.reasonPhrase}");
      return [];
    }
  }

  // New PAYMENT
  Future<void> makePaymentRequest(String bookingId, String cardNumber, String holderName, String ccv, String selectMonth, String selectYear) async {
    print("INSIDEPAYMENT");
    String endpoint = '$baseUrl/payment/create/eway/?api_token=${authService.apiToken}&version=2';

    Map<String, dynamic> requestBody = {
      "booking_id": bookingId,
      "cardholderName": holderName,
      "cardNumber": cardNumber,
      "expiryMonth": selectMonth,
      "expiryYear": selectYear,
      "cvn": ccv
    };
    String basicAuth = 'Basic ' + base64.encode(utf8.encode('$ewayKey:$ewayPassword'));

    print("REQUESPAYMENT");
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{'authorization': basicAuth, 'Content-Type': "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful response
        print('Payment successful!');
        print('Response: ${response.body}');
      } else {
        // Handle error response
        print('Failed to make payment. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error making payment request: $error');
    }
  }

  Future<bool> makePaymentRequest2(String bookingId, String cardNumber, String holderName, String ccv, String selectMonth, String selectYear) async {
    print("INSIDEPAYMENT2");
    var requestBody = {
      "api_token": authService.apiToken,
      "booking_id": bookingId,
      "cardholderName": holderName,
      "cardNumber": cardNumber,
      "expiryMonth": selectMonth,
      "expiryYear": selectYear,
      "cvn": ccv,
    };

    print(requestBody);

    // Convert the request parameters to a query string
    String queryString = Uri(queryParameters: requestBody).query;
    print(queryString);

    // String endpoint = 'https://app.gen21.com.au/api/eway_payment_create/?$queryString';
    String endpoint = 'https://app.gen21.com.au/api/eway_payment_create/?$queryString&version=2';

    // Make the GET request
    print(endpoint);
    var response = await http.get(Uri.parse(endpoint));
    print(response.body);
    if (response.statusCode == 200) {
      print('Payment successful!');
      return true;
    }
    else{
      print('Failed to make payment. Status code: ${response.statusCode}');
      return false;
    }
  }

  // Payment for selected card
  Future<bool> makePaymentRequestSelectCard(String bookingId, String cardId) async {
    var requestBody = {
      "api_token": authService.apiToken,
      "booking_id": bookingId,
      "card_id": cardId,
    };

    print(requestBody);

    // Convert the request parameters to a query string
    String queryString = Uri(queryParameters: requestBody).query;
    print(queryString);

    // String endpoint = 'https://app.gen21.com.au/api/eway_payment_create/?$queryString';
    String endpoint = 'https://app.gen21.com.au/api/eway_payment_create/?$queryString&version=2';

    // Make the GET request
    print(endpoint);
    var response = await http.get(Uri.parse(endpoint));
    print(response.body);
    if (response.statusCode == 200) {
      print('Payment successful!');
      return true;
    }
    else{
      print('Failed to make payment. Status code: ${response.statusCode}');
      return false;
    }
  }

  Future<Map<String, dynamic>> initiateSSLCommerzPayment(String bookingId, String platform) async {
    var _queryParameters = {
      "api_token": authService.apiToken,
      "booking_id": bookingId,
      "type": "booking", // Or as per your requirement
      "platform": platform, // "mobile" for Flutter, "web" for web
    };
    Uri _uri = getApiBaseUri("sslcommerz_payment/initiate").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());

    print("URL FOR SSL");
    print(_uri);

    var response = await _httpClient.postUri(_uri, options: _optionsNetwork);

    print("SSLRESPOSNE");
    print(response.toString());

    if (response.data['success'] == true) {
      return response.data['data']; // This should contain GatewayPageURL
    } else {
      throw Exception(response.data['message']);
    }
  }

  Future<Map<String, dynamic>> getSSLCommerzStatus(String bookingId) async {
    print("LaravelApiClient: Calling getSSLCommerzStatus for bookingId: $bookingId");
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2', // Ensure version is included
    };
    // Adjust the endpoint to match your backend's implementation
    Uri _uri = getApiBaseUri("sslcommerz_payment/status/$bookingId").replace(queryParameters: _queryParameters);
    Get.log("getSSLCommerzStatus URL: ${_uri.toString()}");

    try {
      var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
      print("getSSLCommerzStatus response: Status Code = ${response.statusCode}, Data = ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return response.data; // Expecting a structure like {"success": true, "data": {"status": "completed", ...}}
      } else {
        print("getSSLCommerzStatus failed: Status code ${response.statusCode}, Response: ${response.data}");
        // If the API returns an error response but with 200 status, check for 'success: false'
        if (response.data != null && response.data['success'] == false) {
          throw Exception(response.data['message'] ?? 'Failed to get payment status.');
        }
        throw Exception('Failed to get payment status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception in getSSLCommerzStatus: $e");
      throw Exception('An error occurred while fetching payment status.');
    }
  }


  // New send REQUEST
  Future<bool> sendRequestAfterPayment(String bookingId) async {
    var _queryParameters = {
      "api_token": authService.apiToken,
      "order_id": bookingId,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("send-request").replace(queryParameters: _queryParameters);

    final payload = {'order_id2232': bookingId};
    print("SEND URL.........................");
    print(_uri);
    print(_queryParameters);
    final response = await _httpClient.postUri(
      _uri,
    );

    if (response.statusCode == 200) {
      print('REQUEST SEND successfully!');
      return true;
    }
    else{
      print('Failed to make payment. Status code: ${response.statusCode}');
      return false;
    }
  }

  // Pay TIPS
  Future<bool> payTips(String bookingId, String tipsAmount, String cardNumber, String holderName, String ccv, String selectMonth, String selectYear) async {
    var requestBody = {
      "api_token": authService.apiToken,
      "booking_id": bookingId,
      "amount": tipsAmount,
      "cardholderName": holderName,
      "cardNumber": cardNumber,
      "expiryMonth": selectMonth,
      "expiryYear": selectYear,
      "cvn": ccv,
    };

    // Convert the request parameters to a query string
    String queryString = Uri(queryParameters: requestBody).query;

    // Construct the URL
    // String endpoint = '$baseUrl/eway/payment/tips?$queryString';
    String endpoint = 'https://app.gen21.com.au/api/eway_payment_tips/?$queryString&version=2';

    print(endpoint);
    // Make the GET request
    var response = await http.get(Uri.parse(endpoint));
    print(response.body);
    if (response.statusCode == 200) {
      print('Payment successful!');
      return true;
    }
    else{
      print('Failed to make payment. Status code: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> payTipsWithSelectCard(String bookingId, String tipsAmount, String cardId) async {
    print("ISNDIETIPS");
    var requestBody = {
      "api_token": authService.apiToken,
      "booking_id": bookingId,
      "amount": tipsAmount,
      "card_id": cardId,
    };

    // Convert the request parameters to a query string
    String queryString = Uri(queryParameters: requestBody).query;

    // Construct the URL
    // String endpoint = '$baseUrl/eway/payment/tips?$queryString';
    String endpoint = 'https://app.gen21.com.au/api/eway_payment_tips/?$queryString&version=2';

    print(endpoint);
    // Make the GET request
    var response = await http.get(Uri.parse(endpoint));
    print(response.body);
    if (response.statusCode == 200) {
      print('Payment successful!');
      return true;
    }
    else{
      print('Failed to make payment. Status code: ${response.statusCode}');
      return false;
    }
  }

  Future<String> cardList() async {

    // Construct the URL
    String endpoint = 'https://app.gen21.com.au/api/card-list?api_token=${authService.apiToken}&version=2';

    // Make the GET request
    var response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      print('Payment successful!');
      return response.body;
    }
    else{
      print('Failed to make payment. Status code: ${response.statusCode}');
      return response.body;
    }
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = dio.Options();
    }
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    Uri _uri = getApiBaseUri("slides");
    _uri = _uri.replace(
      queryParameters: {
        ...Uri.splitQueryString(_uri.query),
        'version': '2', // Add the new version parameter
      },
    );

    Get.log(_uri.toString());

    var response = await _httpClient.getUri(_uri, options: _optionsCache);

    if (response.data['success'] == true) {
      return response.data['data'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("login");
    _uri = _uri.replace(
      queryParameters: {
        'version': '2',
      },
    );
    printWrapped("gen_log login() ${json.encode(user.toJson())}");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: jsonEncode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("register"); // Get the base Uri for /register
    _uri = _uri.replace(
      queryParameters: {
        'version': '2',
      },
    );

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: jsonEncode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("send_reset_link_email"); // Get the base Uri for /send_reset_link_email

    // Add the version parameter.
    _uri = _uri.replace(
      queryParameters: {
        'version': '2', // Add the new version parameter
      },
    );

    Get.log(_uri.toString());
    user = new User(email: user.email); // This line seems fine, it's just re-initializing user with email

    var response = await _httpClient.postUri(
      _uri,
      data: jsonEncode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("users/${user.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());

    printWrapped("jfnkjsdaf body: ${json.encode(user.toJson())}");
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );

    printWrapped("jfnkjsdaf response: ${response.toString()}");
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;

      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'orderBy': 'id',
      'sortedBy': 'desc',
      'version': '2',
      'filter': 'my'
    };
    Uri _uri = getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    print("sdjfnsjfs ${response.toString()}");
    if (response.data['success'] == true) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getRecommendedEServices() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'only': 'id;name;price;discount_price;price_unit;has_media;media;total_reviews;rate',
      'limit': '6',
      'version': '2',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    printWrapped("cap_log _queryParameters:${_queryParameters.toString()}");
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAllEServicesWithPagination(String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {'with': 'eProvider;eProvider.addresses;categories', 'search': 'categories.id:$categoryId', 'searchFields': 'categories.id:=', 'limit': '4', 'offset': ((page - 1) * 4).toString(), 'version': '2'};
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    print("MAPSsssss");
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> searchEServices(String keywords, List<String> categories, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
      'version': '2',

    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Favorite>> getFavoritesEServices() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFavoritesEServices() ]");
    }
    var _queryParameters = {
      'with': 'eService;options;eService.eProvider',
      'search': 'user_id:${authService.user.value.id}',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Favorite>((obj) => Favorite.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Favorite> addFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception("You must have an account to be able to add services to favorite".tr + "[ addFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return Favorite.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> removeFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception("You must have an account to be able to add services to favorite".tr + "[ removeFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("favorites/1").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.taxes;categories',
      'version': '2',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<GService> getService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.taxes;categories',
      'version': '2',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("cetegory_details_and_services/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("sdhbfhbash: ${response.toString()}");
    print("sdhbfhbash success: ${response.data['success']} data: ${response.data['data']}");
    // if (response.data['success'] == true) {
    print("${response.data["data"].toString()}");
    return GService.fromJson(response.data);
  }

  Future<ServiceDetails.ServiceDetails> getServiceDetails(String id) async {
    Uri _uri = getApiBaseUri("e_service_details");

    // 2. Construct the query parameters map.
    var _queryParameters = {
      'id': id, // Add the 'id' parameter here
      'with': 'eProvider;eProvider.taxes;categories',
      'version': '2', // Add the 'version' parameter here
    };

    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }

    _uri = _uri.replace(queryParameters: _queryParameters);

    Get.log(_uri.toString()); // This will now correctly show: https://app.gen21.com.au/api/e_service_details?id=36&with=...&version=2&api_token=...

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("sdhbfhbash: ${response.toString()}");
    print("sdhbfhbash success: ${response.data['success']} data: ${response.data['data']}");
    print("${response.data["data"].toString()}");
    return ServiceDetails.ServiceDetails.fromJson(response.data);
  }


  Future<provider.EProvider> getEProvider(String eProviderId) async {
    const _queryParameters = {
      'with': 'eProviderType;availabilityHours;users',
      'version': '2',
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return provider.EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<Review>> getEProviderReviews(String eProviderId) async {
    var _queryParameters = {'with': 'eProviderReviews;eProviderReviews.user', 'only': 'eProviderReviews.id;eProviderReviews.review;eProviderReviews.rate;eProviderReviews.user;','version': '2'};
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    Get.log("sdnfbhaba ${response.toString()}");
    if (response.data['success'] == true) {
      return response.data['data']['e_provider_reviews'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Gallery>> getEProviderGalleries(String eProviderId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2',
    };
    Uri _uri = getApiBaseUri("galleries").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Gallery>((obj) => Gallery.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getEProviderAwards(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2',
    };
    Uri _uri = getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Award>((obj) => Award.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getEProviderExperiences(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2',
    };
    Uri _uri = getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Experience>((obj) => Experience.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(String eProviderId, int page) async {
    var _queryParameters = {'with': 'eProvider;eProvider.addresses;categories', 'search': 'e_provider_id:$eProviderId;featured:1', 'searchFields': 'e_provider_id:=;featured:=', 'searchJoin': 'and', 'limit': '5', 'offset': ((page - 1) * 5).toString(), 'version': '2'};
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderPopularEServices(String eProviderId, int page) async {
    // TODO popular eServices
    var _queryParameters = {'with': 'eProvider;eProvider.addresses;categories', 'search': 'e_provider_id:$eProviderId', 'searchFields': 'e_provider_id:=', 'rating': 'true', 'limit': '4', 'offset': ((page - 1) * 4).toString(), 'version': '2'};
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(String eProviderId, int page) async {
    var _queryParameters = {'with': 'eProvider;eProvider.addresses;categories', 'search': 'e_provider_id:$eProviderId', 'searchFields': 'e_provider_id:=', 'available_e_provider': 'true', 'limit': '4', 'offset': ((page - 1) * 4).toString(), 'version': '2'};
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(String eProviderId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getEProviderEmployees(String eProviderId) async {
    var _queryParameters = {'with': 'users', 'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token','version': '2'};
    Uri _uri = getApiBaseUri("e_providers/$eProviderId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getUsersByUserId(String userId) async {
    var _queryParameters = {
      'with': 'users',
      'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token',
      'user_id': userId,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("single_user").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['user'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderEServices(String eProviderId, int page) async {
    var _queryParameters = {'with': 'eProvider;eProvider.addresses;categories', 'search': 'e_provider_id:$eProviderId', 'searchFields': 'e_provider_id:=', 'searchJoin': 'and', 'limit': '4', 'offset': ((page - 1) * 4).toString(),'version': '2'};
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {'with': 'user', 'only': 'created_at;review;rate;user', 'search': "e_service_id:$eServiceId", 'orderBy': 'created_at', 'sortBy': 'desc', 'limit': '10','version': '2'};
    Uri _uri = getApiBaseUri("e_service_reviews").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {'with': 'options;options.media', 'only': 'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media', 'search': "options.e_service_id:$eServiceId", 'searchFields': 'options.e_service_id:=', 'orderBy': 'name', 'sortBy': 'desc','version': '2'};
    Uri _uri = getApiBaseUri("option_groups").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getFeaturedEServices(String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId;featured:1',
      'searchFields': 'categories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'version': '2'
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getPopularEServices(String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'version': '2'
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getMostRatedEServices(String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'version': '2'
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAvailableEServices(String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {'with': 'eProvider;eProvider.addresses;categories', 'search': 'categories.id:$categoryId', 'searchFields': 'categories.id:=', 'available_e_provider': 'true', 'limit': '4', 'offset': ((page - 1) * 4).toString(), 'version': '2'};
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2', // <-- Add this line
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters); // Assuming getApiBaseUri returns Uri and we use replace
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      print("KYToito categories ${response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList()}");
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getSubCategories(String categoryId) async {
    final _queryParameters = {
      'search': "parent_id:$categoryId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredEServices',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
      'version': '2'
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception("Data not found");
      // print("Not working Now");
    }
  }

  Future<Category> getCategory(String id) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.taxes;categories',
      'version': '2'
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("categories/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Category.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Booking>> getBookings(String statusId, int page, orderId) async {
    print("sdnfja getBookings() called");

    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      // 'search': 'user_id:${authService.user.value.id}',
      'is_provider_app': null,
      // 'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'id': orderId,
      'offset': ((page - 1) * 4).toString(),
      'version': '2'
    };
    printWrapped("jsndfjkjsa queryParams: ${_queryParameters.toString()}");
    Uri _uri = getApiBaseUri("order-details").replace(queryParameters: _queryParameters);

    Get.log(_uri.toString());
    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    var response = await _httpClient.postUri(_uri, options: _optionsNetwork);
    print("sfbhafhsh response: ${response.toString()}");
    if (response.data['success'] == true) {
      return response.data['data'].map<Booking>((obj) => Booking.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<BookingModelNew.BookingNew>> getBookingsNew(int page, orderId) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'is_provider_app': null,
      // 'booking_status_id': '${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '100',
      'id': orderId,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("booking-list").replace(queryParameters: _queryParameters);

    print("736635 queryParams: ${_queryParameters.toString()}");
    print("736635 _uri.toString(): ${_uri.toString()}");

    Get.log(_uri.toString());
    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    var response = await _httpClient.postUri(_uri, options: _optionsNetwork);
    printWrapped("736635 getBookingsNew response In User APP: ${response.toString()}");
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingModelNew.BookingNew>((obj) => BookingModelNew.BookingNew.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingModelNew.BookingNew>> getPendingBookings(int page, orderId) async {
    print("jfkamsfdsfds getBookingsNew() called");
    var _queryParameters = {
      'api_token': authService.apiToken,
      'is_provider_app': null,
      // 'booking_status_id': '${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '100',
      'id': orderId,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("pending-booking-list").replace(queryParameters: _queryParameters);

    print("jfkamsfdsfds queryParams: ${_queryParameters.toString()}");
    print("jfkamsfdsfds _uri.toString(): ${_uri.toString()}");

    Get.log(_uri.toString());
    // var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    var response = await _httpClient.postUri(_uri, options: _optionsNetwork);
    printWrapped("jfkamsfdsfds getBookingsNew response In User APP: ${response.toString()}");
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingModelNew.BookingNew>((obj) => BookingModelNew.BookingNew.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("booking_statuses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingStatus>((obj) => BookingStatus.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getBookingStatuses()");
      // throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with': 'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in getBooking()");

      throw new Exception(response.data['message']);
    }
  }

  Future<BookingModelNew.BookingNew> getBookingDetails(String bookingId) async {
    print("getBookingDetails123");
    print(bookingId);
    var _queryParameters = {
      'with': 'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("kjsndjkf response.toString(): ${response.toString()}");
    print("kjsndjkf response.statusCode: ${response.statusCode}");
    print("kjsndjkf response.statusMessage: ${response.statusMessage}");
    if (response.data['success'] == true) {
      return BookingModelNew.BookingNew.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in getBookingDetails()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Coupon> validateCoupon(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': booking.coupon?.code ?? '',
      'e_service_id': booking.eService?.id ?? '',
      'e_provider_id': booking.eService?.eProvider?.id ?? '',
      'categories_id': booking.eService?.categories?.map((e) => e.id)?.join(",") ?? '',
      'version': '2'
    };
    print("Queryparam");
    print(_queryParameters);
    Uri _uri = getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("REPONSE");
    print(response);
    if (response.data['success'] == true) {
      return Coupon.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in validateCoupon()");
      throw new Exception(response.data['message']);
    }
  }

  Future<Coupon> validateCouponByCode(String code) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': code ?? '',
      'version': '2',
    };
    Uri _uri = getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true && response.data['data'] != null) {
      return Coupon.fromJson(response.data['data']);
    } else if (response.data['data'] == null) {
      throw new Exception("Invalid Coupon");
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in updateBooking()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBookingNew(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateBooking() ]");
    }

    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': booking.id,
      'booking_status_id': booking.status.id,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("booking-status-update").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    print("fsnflasd ${booking.toJson()} _optionsNetwork: ${_optionsNetwork.toString()}");

    var response = await _httpClient.postUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    print("jsnfjsansdkll ${response.toString()}");
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in updateBookingNew()");

      throw new Exception(response.data['message']);
    }
    // print("jsnfjsansdkll result: ${result.toString()}");

    // return null;
  }

  Future<Booking> addBooking(Booking booking) async {
    print("ADDBOOKING");
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    print("sndjfasn ${booking.toJson()}");
    var response = await _httpClient.postUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in addBooking()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addReview(Review review) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("e_service_reviews").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: review.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in addReview()");
      throw new Exception(response.data['message']);
    }
  }


  Future<Review> addProviderReview(Review review, EProvider eProvider, String bookingId) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };

    var data = {
      "review": "${review.review}",
      "rate": "${review.rate}",
      "user_id": "${review.user.id}",
      "e_provider_user_id": "${eProvider.id}",
      'booking_id': "$bookingId",
    };

    print("jsnjfdsakj ${data.toString()}");

    Uri _uri = getApiBaseUri("e_provider_reviews").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    print("jsnjfdsakj ${_uri}");
    var response = await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in addProviderReview()");

      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("payment_methods").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getPaymentMethods()");

      throw new Exception(response.data['message']);
    }
  }

  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Wallet>((obj) => Wallet.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getWallets()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in createWallet()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in updateWallet()");

      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      print("kdsjknfsdjk exception happen in deleteWallet()");

      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("wallet_transactions").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getWalletTransactions()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("payments/cash").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in createPayment()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2',
    };
    Uri _uri = getApiBaseUri("payments/wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in createWalletPayment()");

      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/paypal/express-checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/razorpay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/stripe/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/paystack/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/paymongo/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/flutterwave/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
      'version': '2',
    };
    Uri _uri = getBaseUri("payments/stripe-fpx/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    printWrapped("sjdnfjsajk ${_uri.toString()}");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    printWrapped("sjdnfjsajk ${response.toString()}");

    if (response.statusCode == 200) {
      return response.data.map<Notification>((obj) => Notification.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getNotifications()");

      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsForID() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    printWrapped("sjdnfjsajk ${_uri.toString()}");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    printWrapped("sjdnfjsajk ${response.toString()}");
    var ieee = response.data.map<Notification>((obj) => Notification.fromJson(obj)).toList();
    var bookingId2;
    for (Notification notification in ieee) {
      bookingId2 = notification.data['booking_id'];
      // print('Booking_ID: $bookingId2');
      break;
    }

    if (response.statusCode == 200) {
      return bookingId2;
    } else {
      print("kdsjknfsdjk exception happen in getNotifications()");
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in markAsReadNotification()");

      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };

    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    printWrapped("fjnjkansj !_queryParameters ${_queryParameters.toString()}");
    printWrapped("fjnjkansj !data ${data.toString()}");

    var response = await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      print("kdsjknfsdjk exception happen in sendNotification()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in removeNotification()");

      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("notifications/count").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    printWrapped("sjdnfjsajk ${_uri.toString()}");
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    printWrapped("sjdnfjsajk ${response.toString()}");

    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      print("kdsjknfsdjk exception happen in getNotificationsCount()");

      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("faq_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<FaqCategory>((obj) => FaqCategory.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getFaqCategories()");

      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Faq>((obj) => Faq.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getFaqs()");

      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("settings");
    Get.log(_uri.toString());
    print("seeting api call");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    // printWrapped("kdsjknfsdjk response: ${response.toString()}");
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in getSettings()");
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("custom_pages").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<CustomPage>((obj) => CustomPage.fromJson(obj)).toList();
    } else {
      print("kdsjknfsdjk exception happen in getCustomPages()");

      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      print("kdsjknfsdjk exception happen in getCustomPageById()");

      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("uploads/store").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      print("kdsjknfsdjk exception happen in uploadImage()");

      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      print("kdsjknfsdjk exception happen in deleteUploaded()");

      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      print("kdsjknfsdjk exception happen in deleteAllUploaded()");

      throw new Exception(response.data['message']);
    }
  }


  Future<List<SearchSuggestion>> getSearchSuggestions({String searchedData}) async {
    print("sdnkjsna getSearchSuggestions called in laravel provider");

    var _queryParameters = {
      'name': '${searchedData}',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("category-search").replace(queryParameters: _queryParameters);
    print("LION");
    print("jnfjsanfdakj ${_uri.toString()}");
    // Get.log(_uri.toString());

    try {
      var response = await _httpClient.postUri(_uri, options: _optionsCache);
      print("jnfjsanfdakj ${response.toString()}");

      if (response.statusCode == 200) {
        return response.data['data'].map<SearchSuggestion>((obj) => SearchSuggestion.fromJson(obj)).toList();
      } else {
        throw new Exception("Something went wrong!");
      }
    } catch (e) {
      print("jnfjsanfdakj in laravel_provider ${e.toString()}");
    }
  }

  Future<SubService> getSubService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.taxes;categories',
      'version': '2'
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("service_subtype/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("fsjfsads5: ${response.toString()}");
    print("fsjfsads6 status: ${response.data['success']} data: ${response.data['data']}");

    if (response.data['success'] == true) {
      print("fsjfsads0003: response.data['data'] ${response.data["data"].toString()}");
      return SubService.fromJson(response.data);
    } else {
      print("fsjfsads0003 in exception");
      print("kdsjknfsdjk exception happen in getSubService()");

      throw new Exception(response.data['message']);
    }
  }


  Future<Map<String, dynamic>> submitBookingRequest2({var data}) async {
    print(data);
    if (!authService.isAuth) {
      throw Exception("You don't have permission to access this area!".tr + "[ addBooking() ]");
    }

    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };

    print("api_token ${authService.apiToken}");
    Uri _uri = getApiBaseUri("booking-request").replace(queryParameters: _queryParameters);

    printWrapped("jnsdfsak2323 url: ${_uri.toString()}");
    printWrapped("data: ${data.toString()}");

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: data,
      options: Options(
        headers: {
          'Content-type': 'application/json',
        },
      ),
    );

    print("BOOKIING REQUEST1:");
    print(response);

    printWrapped("responseSubmit2 ${response.data.toString()}");
    valueForResponse = response.data['data']['booking_id'];
    valueForOrderId = response.data['data']['order_id'];

    ApiResponse data2 = OrderRequestResponseModelBookingId.ApiResponse.fromJson(response.data);

    return data2.data;
  }



  Future<OrderRequestResponseModel.OrderRequestResponse> submitBookingRequest({var data}) async {

    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    print("jnsdfsakdfaa api_token ${authService.apiToken}");

    Uri _uri = getApiBaseUri("booking-request").replace(queryParameters: _queryParameters);
    printWrapped("jnsdfsakdfaal url: ${_uri.toString()}");
    printWrapped("jnsdfsakdfaal data: ${data.toString()}");

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: data,
      options: Options(
        headers: {
          'Content-type': 'application/json',
        },
      ),
    );

    print("BOOKIING REQUEST2:");
    print(response);

    printWrapped("jnsdfsakdfaal response ${response.data.toString()}");
    printWrapped("jnsdfsakdfaal statusCode ${response.statusCode.toString()}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("dfbhaadsa in if");
      print(OrderRequestResponseModel.OrderRequestResponse.fromJson(response.data));
      return OrderRequestResponseModel.OrderRequestResponse.fromJson(response.data);
    } else {
      print("dfbhaadsa in else");
      print("kdsjknfsdjk exception happen in submitBookingRequest()");

      throw new Exception(response.data['message']);
    }
  }

  Future<bool> submitManualBookingRequest({var data}) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    print("snfjsanjfnds api_token ${authService.apiToken}");
    Uri _uri = getApiBaseUri("manual-booking-request").replace(queryParameters: _queryParameters);

    // _optionsNetwork.headers.c = 'application/json';
    print("sdfbas url: ${_uri.toString()}");

    print("snfjsanjfnds response1 ${_optionsNetwork.headers.toString()}");
    printWrapped("snfjsanjfnds response2 ${_httpClient.options.headers.toString()}");
    printWrapped("snfjsanjfnds data ${data.toString()}");

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: data,
      options: Options(
        headers: {
          'Content-type': 'application/json',
        },
      ),
    );

    printWrapped("dfbhaadsa response ${response.toString()}");
    print("dfbhaadsa data ${data.toString()}");
    print("dfbhaadsa response.statusCode ${response.statusCode}");
    print("dfbhaadsa response.statusMessage ${response.statusMessage}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // print("dfbhaadsa in ${response.data['success']}");
      return true;
    } else {
      print("dfbhaadsa in else");
      print("kdsjknfsdjk exception happen in submitManualBookingRequest()");
      throw new Exception(response.data['message']);
    }
  }

  Future<List<ProvidersData.Data>> searchProviders({var data}) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    print("sdjnfkdafssd api_token ${authService.apiToken}");
    // var tempData = data.toJson();
    // print("jsndjkfda tempData: ${tempData}");
    Uri _uri = getApiBaseUri("e_multiple_service_providers").replace(queryParameters: _queryParameters);

    // _optionsNetwork.headers.c = 'application/json';

    printWrapped("sdjnfkdafssd response1 ${_optionsNetwork.headers.toString()}");
    printWrapped("sdjnfkdafssd response2 ${_httpClient.options.headers.toString()}");
    printWrapped("sdjnfkdafssd data ${data.toString()}");

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: data,
      options: Options(
        headers: {
          'Content-type': 'application/json',
        },
      ),
    );

    printWrapped("sdjnfkdafssd response ${response.toString()}");
    if (response.statusCode == 200) {
      print("nfdsanaa in if");
      // return EProvider.fromJson(response.data);
      print("dfbhaadsa response.data['data'] ${response.data['data'].toString()}");
      var test = response.data['data'].map<ProvidersData.Data>((obj) => ProvidersData.Data.fromJson(obj)).toList();
      print("dfbhaadsa response2 ${test.toString()}");

      return test;
    } else {
      print("dfbhaadsa in else");
      print("kdsjknfsdjk exception happen in searchProviders()");

      throw new Exception(response.data['message']);
    }
  }

  Future<OrderModel.Orders> getOrders() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'order_by': "DESC",
      'limit': '50',
      'version': '2'
    };
    Uri _uri = getApiBaseUri("order-list").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print("sjdnfab response ${response.toString()}");
    // if (response.data['success'] == true) {
    var temp = OrderModel.Orders.fromJson(response.data);
    // var temp = OrderModel.fromJson(response.data);
    print("dsfajd ${temp.toString()}");
    return temp;

  }

  Future<bool> cancelOrder(String orderId) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'order_id': orderId,
      'version': '2'
    };
    Uri _uri = getApiBaseUri("cancel-request").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    print("BEFORERESS");
    var response = await _httpClient.postUri(_uri, options: _optionsNetwork);
    print("CHEKKKKRESPONSE");
    print(response);
    print("jdfnjsjjdf ${response.data}");
    if (response.data['success'] == true) {
      return true;
    } else {
      print("jdfnjsjjdf exception happen in cancelOrder()");
      // throw new Exception(response.data['message']);
    }
  }

  Future<eWayInitiateResponseRef.EwayInitiateResponse> initiateEway(var bodyData) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    Uri eWayUri = Uri.parse("${eWayBaseUrl}AccessCodesShared");
    print("CHECKEWAYURL");
    print(eWayUri);

    String basicAuth = 'Basic ' + base64.encode(utf8.encode('$ewayKey:$ewayPassword'));

    var response = await http.post(
      eWayUri,
      headers: <String, String>{'authorization': basicAuth, 'Content-Type': "application/json"},
      body: json.encode(bodyData),
    );

    printWrapped("jsndjnfka response.body.toString(): ${response.body.toString()}");
    if (response.statusCode == 200) {
      return eWayInitiateResponseRef.EwayInitiateResponse.fromJson(jsonDecode(response.body));
    } else {
      print("kdsjknfsdjk exception happen in initiateEway()");
      throw new Exception("Something went wrong");
    }

  }

  Future<bool> submitEWayPaymentResult({var bodyData}) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'version': '2'
    };
    print("jsdnfbkdsbf api_token ${authService.apiToken}");
    print("jsdnfbkdsbf bodyData ${bodyData}");
    print("jsdnfbkdsbf json.encode(bodyData) ${json.encode(bodyData)}");

    Uri _uri = getApiBaseUri("payment_status").replace(queryParameters: _queryParameters);
    print("jsdnfbkdsbf url: ${_uri.toString()}");

    print("jsdnfbkdsbf _optionsNetwork.headers.toString() ${_optionsNetwork.headers.toString()}");
    print("jsdnfbkdsbf _httpClient.options.headers.toString() ${_httpClient.options.headers.toString()}");

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(bodyData),
      options: Options(
        headers: {
          'Content-type': 'application/json',
        },
      ),
    );

    printWrapped("jsdnfbkdsbf response ${response.data.toString()}");
    printWrapped("jsdnfbkdsbf statusCode ${response.statusCode.toString()}");
    printWrapped("jsdnfbkdsbf response.data['status'] ${response.data['status']}");
    if ((response.statusCode == 200 || response.statusCode == 201) && response.data['status'] == true) {
      print("jsdnfbkdsbf in if");
      // return OrderRequestResponseModel.OrderRequestResponse.fromJson(response.data);
      return true;
    } else {
      print("jsdnfbkdsbf in else");
      // throw new Exception(response.data['message']);
      // throw new Exception("Something went wrong!");
      return false;
    }
  }
}
