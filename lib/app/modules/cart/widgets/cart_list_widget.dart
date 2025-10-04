import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/sub_service/widgets/sub_service_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controller/add_to_cart_controller.dart';
import 'cart_list_item_widget.dart';

class CartListWidget extends GetView<AddToCartController> {
  CartListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var carts = controller.addToCartData.value;

      if (carts.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: carts.length,
          itemBuilder: ((_, index) {

              var cart = carts.elementAt(index);
              return CartListItemWidget(cart: cart);
          }),
        );
      }
    });
  }
}
