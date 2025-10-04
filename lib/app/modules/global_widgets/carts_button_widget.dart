import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../cart/controller/add_to_cart_controller.dart';
import '../root/controllers/root_controller.dart';

class CartsButtonWidget extends GetView<AddToCartController> {
  // final AddToCartController _addToCartController =
  // Get.put(AddToCartController());
   const CartsButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      height: 0,
      // padding: EdgeInsets.only(right: 5),
      hoverElevation: 0,
      highlightElevation: 0,
      elevation: 0,
      onPressed: () {
        if (Get.find<AuthService>().isAuth == true) {
          Get.toNamed(Routes.CART);
        } else {
          Get.toNamed(Routes.LOGIN);
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.shopping_cart_outlined,
            color: iconColor ?? Get.theme.hintColor,
            size: 28,
          ),
          Container(
            child: Obx(() {
              return Center(
                child: Text(
                 controller.addToCartData.length.toString(),
                  textAlign: TextAlign.center,
                  style: Get.textTheme.caption.merge(
                    TextStyle(color: Get.theme.primaryColor, fontSize: 9, height: 1.4),
                  ),
                ),
              );
            }),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: labelColor ?? Get.theme.colorScheme.secondary, borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(minWidth: 16, maxWidth: 16, minHeight: 16, maxHeight: 16),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
