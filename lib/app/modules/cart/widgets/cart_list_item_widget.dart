/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/keywords_helper.dart';
import '../../../../common/sqf_lite_key.dart';
import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/service_model.dart';
import '../../../models/sub_service_model.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controller/add_to_cart_controller.dart';

class CartListItemWidget extends StatelessWidget {
  final AddToCartController _addToCartController =
      Get.put(AddToCartController());

  CartListItemWidget({
    Key key,
    @required AddToCart cart,
  })  : _cart = cart,
        super(key: key);

  final AddToCart _cart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.E_SERVICE,
        //     arguments: {'cart': _cart, 'heroTag': 'service_list_item'});
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: Ui.getBoxDecoration(),
          child: Row(
            children: [
              Hero(
                tag: 'service_list_item ${_cart.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: _cart.image_url != null
                        ? _cart.image_url
                        : KeywordsHelper.noImageUrl,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 80,
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_cart.service_name}",
                        style: Get.textTheme.bodyText2.copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (_cart.type == SqfLiteKey.subService)
                        Text(
                          "${_cart.name}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Ui.getPrice(
                        double.parse(_cart.price),
                        style: Get.textTheme.headline3.merge(TextStyle(
                            fontSize: 14,
                            color: Get.theme.colorScheme.secondary)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          _addToCartController.removeFromCart(
                                              _cart.service_id, _cart.type);
                                        },
                                        child: Icon(
                                          Icons.delete_forever_outlined,
                                          color:
                                              Get.theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.secondary,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            bottomLeft: Radius.circular(6)),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _addToCartController.decrement(
                                              _cart.service_id,
                                              _cart.type,
                                              int.parse(_cart.minimum_unit));
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.secondary
                                            .withOpacity(.1),
                                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                      ),
                                      child: Text("${_cart.added_unit}"),
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Get.theme.colorScheme.secondary,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            _addToCartController.increment(
                                                _cart.service_id,
                                                _cart.type,
                                                int.parse(_cart.minimum_unit));
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ))),
                                    ),
                                  ],
                                ),
                                // child: Text("item ${_addToCartController.findItemInArray(_service.id) >-1? _addToCartController.addToCartData[_addToCartController.findItemInArray(_service.id)].added_unit : 1}"),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
