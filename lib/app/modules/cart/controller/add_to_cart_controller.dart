import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/address_model.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_model.dart';
import '../../../providers/database_helper.dart';
import '../../../repositories/cart_repository.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class AddToCartController extends GetxController {
  CartRepository _cartRepository;
  var addToCartData = List<AddToCart>().obs;

  // var addToCartObs =  AddToCart().obs;
  final isLoading = false.obs;

  AddToCartController() {
    _cartRepository = new CartRepository();
  }

  @override
  Future<void> onInit() async {
    await getAllAddToCartData();
    await loadDB();
    super.onInit();
  }

  loadDB() async {
    await _cartRepository.openDB();
    await getCartList();
  }

  // getCardList() async{
  //   try {
  //     List list = await itemServices.getCartList();
  //     cartItems.clear();
  //     list.forEach((element) {
  //       cartItems.add(ShopItemModel.fromJson(element));
  //     });
  //     update();
  //
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  getAllAddToCartData() async {
    isLoading.value == true;
    addToCartData.value = await DatabaseHelper.instance.getAllAddToCartData();
    print("djnfnaKl in getAllAddToCartData() of addto cart controller ${addToCartData.toString()}");
    isLoading.value == false;
  }

  getCartList() async {
    isLoading.value == true;
    var cartListData = await _cartRepository.getCartList();
    addToCartData.value = cartListData;
    isLoading.value == false;
  }

  // void addData(AddToCart addToCart) async {
  //   print("djnfnaKl inn add");
  //   addToCartData.insert(0, addToCart);
  //   // addToCartObs.value = addToCart;
  //   await DatabaseHelper.instance.insert(addToCart);
  //   // taskData.insert(0, AddToCart(addToCart));
  //   // addTaskController.clear();
  // }

  // Future<int> find(String serviceId, type) async {
  //   print("djnfnaKl inn find");
  //
  //   // AddToCart addToCart = new AddToCart();
  //   return await DatabaseHelper.instance.find(serviceId, type);
  //   // taskData.insert(0, AddToCart(addToCart));
  //   // addTaskController.clear();
  // }

  int findItemInArray(String id, type) {
    return addToCartData.indexWhere((cart) => cart.service_id == id && cart.type == type);
  }

  // Future<int> updateCartValue(String id, String type, String currentAddedUnit) async {
  //   print("djnfnaKl inn update");
  //
  //   // AddToCart addToCart = new AddToCart();
  //   // int objIndex = addToCartData.indexOf((cartData));
  //   var index = findItemInArray(id, type);
  //
  //   print(
  //       "djnfnaKl cartData index: $index data: ${addToCartData[index].toString()}");
  //
  //   // addToCartData[index]
  //   addToCartData[index].added_unit =
  //       (int.parse(addToCartData[index].added_unit) + 1).toString();
  //   print(
  //       "djnfnaKl updated cartData index: $index data: ${addToCartData[index].toString()}");
  //   addToCartData.refresh();
  //   return await DatabaseHelper.instance.update(id, currentAddedUnit);
  //
  //   // addTaskController.clear();
  // }

  double totalAmount() {
    double amount = 0;
    addToCartData.forEach((element) {
      try {
        print("jdsfnjkas ${element.price} ${element.added_unit}");
        amount += (double.parse(element.price) * double.parse(element.added_unit));
      } catch (e) {
        print("jdsfnjkas  exception: ${e.toString()}");
      }
    });
    return amount;
  }

  insertToCart(AddToCart addToCart) async {
    print("sjndfjsan addToCart called ${addToCart.toString()}");
    // await DatabaseHelper.instance.insert(addToCart);
    int insertedId = await _cartRepository.insertToCart(addToCart);

    if (insertedId > 0) {
      addToCartData.add(addToCart);
      print("djnfnaKl inserted addToCartData data: ${addToCartData.toString()}");
      addToCartData.refresh();
    }
  }

  removeFromCart(String serviceId, String type) async {
    print("sjndfjsan removeFromCart called in controller");
    _cartRepository.removeFromCart(serviceId, type);
    int index = addToCartData.indexWhere((element) => element.service_id == serviceId && element.type == type);
    addToCartData.removeAt(index);
    update();
  }

  increment(String id, type, int minimumUnit) async {
    var addedCartUnit = await findAddedCartUnit(id, type);
    print("sdsafdshb addedCartUnit $addedCartUnit");
    var updatedUnit = addedCartUnit + (minimumUnit == 0 ? 1 : minimumUnit);
    var increment = await _cartRepository.increment(id, type, updatedUnit);

    if (increment > 0) {
      int index = addToCartData.indexWhere((element) => element.service_id == id && element.type == type);
      addToCartData[index].added_unit = updatedUnit.toString();
      print("djnfnaKl updated cartData index: $index data: ${addToCartData[index].toString()}");
      addToCartData.refresh();
    }
  }

  decrement(String id, type, int minimumUnit) async {
    var addedCartUnit = await findAddedCartUnit(id, type);
    print("sdsafdshb addedCartUnit $addedCartUnit");
    var remainingUnit = addedCartUnit - (minimumUnit == 0 ? 1 : minimumUnit);
    print("sdsafdshb remainingUnit $remainingUnit");

    if (remainingUnit > 0) {
      var decrement = await _cartRepository.decrement(id, type, remainingUnit);
      if (decrement > 0) {
        int index = addToCartData.indexWhere((element) => element.service_id == id && element.type == type);
        addToCartData[index].added_unit = remainingUnit.toString();
        print("djnfnaKl updated cartData index: $index data: ${addToCartData[index].toString()}");
        addToCartData.refresh();
      }
      print("sdsafdshb decrement: $decrement");
    } else {
      print("sdsafdshb in else");
      await _cartRepository.removeFromCart(id, type);
      int index = addToCartData.indexWhere((element) => element.service_id == id && element.type == type);
      addToCartData.removeAt(index);
      update();
    }
  }

  Future<int> findAddedCartUnit(String id, type) {
    return _cartRepository.findAddedCartUnit(id, type);
  }

  Future deleteAllCart() async {
    await  _cartRepository.deleteAllCart();
    getCartList();
  }
}
