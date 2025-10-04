/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../common/keywords_helper.dart';
import '../../../../common/sqf_lite_key.dart';
import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/service_model.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import 'service_details_and_faq_dialog.dart';

class ServiceListItemWidget extends StatelessWidget {
  final AddToCartController _addToCartController = Get.put(AddToCartController());

  ServiceListItemWidget({
    Key key,
    @required EServices service,
  })  : _service = service,
        super(key: key);

  final EServices _service;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var addToCardData = _addToCartController.addToCartData;
      print("djnfnaKl ${addToCardData.toString()}");

      print("sdnkjfnajk service: _service.price: ${_service.price}  service.minPrice: ${_service.minPrice} _service.maxPrice: ${_service.maxPrice}");
      return GestureDetector(
        onTap: () {
          // Get.toNamed(Routes.E_SERVICE, arguments: {
          //   'eService': _service,
          //   'heroTag': 'service_list_item'
          // });
        },
        child: Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: Ui.getBoxDecoration(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Hero(
                              tag: 'service_list_item ${_service.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                child: CachedNetworkImage(
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  imageUrl: _service.media.length > 0 ? _service.media[0].url : KeywordsHelper.noImageUrl,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 80,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    _service.name.en ?? '',
                                    style: Get.textTheme.bodyText2,
                                    maxLines: 3,
                                    // textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Minimum Unit:".tr,
                                      style: Get.textTheme.caption.merge(TextStyle(
                                        color: Colors.grey,
                                      ))),
                                  Text(" ${_service.minimumUnit > 0? _service.minimumUnit : 1}",
                                      style: Get.textTheme.caption.merge(TextStyle(
                                        color: Colors.grey,
                                      )))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),

                                  // Text( "Price:".tr,
                                  //     style: Get.textTheme.caption.merge(TextStyle(
                                  //       color: Colors.grey,
                                  //     ))),
                                  // Text(" ${_service.price}",
                                  //     style: Get.textTheme.caption.merge(TextStyle(
                                  //       color: Colors.grey,
                                  //     ))),

                                  _service.hasSubType == false && _service.price != null && _service.price > 0
                                      ? Row(
                                    children: [
                                      Text("Price ",
                                          style: Get.textTheme.caption
                                              .merge(TextStyle(fontSize: 12))),
                                      Ui.getPrice(
                                        _service.price,
                                        style: Get.textTheme.headline3.merge(TextStyle(
                                            fontSize: 14,
                                            color: Get.theme.colorScheme.secondary)),
                                      )
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      Text("Starts from ",
                                          style: Get.textTheme.caption
                                              .merge(TextStyle(fontSize: 12))),
                                      Ui.getPrice(
                                        _service.minPrice,
                                        style: Get.textTheme.headline3.merge(TextStyle(
                                            fontSize: 14,
                                            color: Get.theme.colorScheme.secondary)),
                                      )
                                    ],
                                  )

                                  // below codes are to handle discount
                                  // if(_service.discountPrice > 0)
                                  //   Text(" ${_service.price}",
                                  //       style: Get.textTheme.caption.merge(TextStyle(
                                  //         color: Colors.grey, decoration: TextDecoration.lineThrough
                                  //       ))),
                                  // Text(" ${_service.discountPrice <= 0? _service.price : _service.discountPrice}",
                                  //     style: Get.textTheme.caption.merge(TextStyle(
                                  //       color: Colors.grey,
                                  //     )))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 10,
                      top: 5,
                      child: InkWell(
                        onTap: (){
                          Get.dialog(ServiceDatailsAndFaqDialog(service: _service));
                        },
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Get.theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),


                Divider(
                  color: Colors.grey.shade500,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _addToCartController.findItemInArray(_service.id, SqfLiteKey.service) > -1
                          ? Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        _addToCartController.removeFromCart(_service.id, SqfLiteKey.service);
                                      },
                                      child: Icon(
                                        Icons.delete_forever_outlined,
                                        color: Get.theme.colorScheme.secondary,
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
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // _addToCartController.removeFromCart(_service.id, SqfLiteKey.service);
                                        _addToCartController.decrement(_service.id, SqfLiteKey.service, _service.minimumUnit);
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 5, right: 5),
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
                                      color: Get.theme.colorScheme.secondary.withOpacity(.1),
                                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                                    ),
                                    child: Text("${_addToCartController.addToCartData[_addToCartController.findItemInArray(_service.id, SqfLiteKey.service)].added_unit}"),
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          // addToCart(_addToCartController);
                                          _addToCartController.increment(_service.id, SqfLiteKey.service, _service.minimumUnit);
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 5, right: 5),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ))),
                                  ),
                                ],
                              ),
                              // child: Text("item ${_addToCartController.findItemInArray(_service.id) >-1? _addToCartController.addToCartData[_addToCartController.findItemInArray(_service.id)].added_unit : 1}"),
                            )
                          : _service.hasSubType != true
                              ? GestureDetector(
                                  onTap: () {
                                    print("djfjsanfd Cheking data");
                                    // addToCart(_addToCartController);

                                    _addToCartController.insertToCart(AddToCart(type: SqfLiteKey.service, service_name: _service.name.en, service_id: _service.id, name: _service.name.en, image_url: _service.media != null && _service.media.length > 0 ? _service.media[0].url : "", price: "${_service.price}", discount_price: "${_service.discountPrice}", minimum_unit: "${_service.minimumUnit}", added_unit: "${_service.minimumUnit < 1 ? 1 : _service.minimumUnit}"));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Text("Add".tr, style: (TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    print("gugyu ${_service.id}");
                                    Get.toNamed(Routes.SUB_SERVICE, arguments: {'heroTag': 'test', 'service_id': _service.id});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Text("See options".tr, style: (TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                                  ),
                                )
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }

}


