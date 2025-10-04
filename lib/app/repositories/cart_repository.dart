import 'package:get/get.dart';

import '../models/add_to_cart_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/coupon_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';
import '../providers/database_helper.dart';
import '../providers/sqflite_provider.dart';

class CartRepository {
  // SqfLiteProvider _sqfLiteProvider = SqfLiteProvider();
  SqfLiteProvider _sqfLiteProvider ;

  CartRepository() {
    this._sqfLiteProvider = SqfLiteProvider();
  }

  Future openDB() async {
    print("sjndfjsan openDB() called");
    return await _sqfLiteProvider.openDB();
  }

  // Future addToCart(AddToCart data) async {
  //   return await _sqfLiteProvider.addToCart(data);
  // }

  Future<List<AddToCart>> getCartList() async {
    return await _sqfLiteProvider.getCartList();
  }

  Future<int> insertToCart(AddToCart addToCart) async {
    print("sjndfjsan removeFromCart called in repository");
    return await _sqfLiteProvider.insertToCart(addToCart);
  }


  removeFromCart(String serviceId, String type) async {
    print("sjndfjsan removeFromCart called in repository");
    // return await _sqfLiteProvider.removeFromCart(serviceId, type);
     print( "sjndfjsan ${await _sqfLiteProvider.removeFromCart(serviceId, type)}");
  }

  Future<int> findAddedCartUnit(String id, String type) async{
    return await _sqfLiteProvider.findAddedCartUnit(id, type);
  }

  Future<int> decrement(String id, String type, int remainingUnit) async{
    return await _sqfLiteProvider.updateCart(id, type, remainingUnit);
  }

  Future<int> increment(String id, String type, int minimumUnit) async{
    return await _sqfLiteProvider.updateCart(id, type, minimumUnit);
  }

  Future deleteAllCart() async{
    return await _sqfLiteProvider.deleteAllCart();
  }



}
