import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/coupon_model.dart';
import '../../providers/laravel_provider.dart';

class UserCoupon extends StatefulWidget {
  @override
  _UserCouponState createState() => _UserCouponState();
}

class _UserCouponState extends State<UserCoupon> {

  var coupons = [];
  bool boxVisible = true;
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();


  @override
  void initState() {
    super.initState();
    // fetchCoupons();
    callingCoupons();
  }

  void callingCoupons() async {
    List<Coupon> fetchedCoupons = await _laravelApiClient.fetchCoupons();
    setState(() {
      coupons = fetchedCoupons;
    });
    print("COUPNSLIST");
    print(coupons);
  }


  void onBoxClick() {
    setState(() {
      boxVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: boxVisible
              ? GestureDetector(
            onTap: onBoxClick,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Coupons',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  for (Coupon coupon in coupons)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Code: ${coupon.code}'),
                          Text('Discount: ${coupon.discount}%'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )
              : Text(
            'Coupon collected successfully. Please apply on the booking time.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
