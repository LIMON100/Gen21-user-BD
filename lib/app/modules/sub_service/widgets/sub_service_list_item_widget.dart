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

class SubServiceListItemWidget extends StatelessWidget {
  final AddToCartController _addToCartController = Get.put(AddToCartController());

  SubServiceListItemWidget({
    Key key,
    serviceName,
    subServiceResponse,
    @required ESubService subService,
  })  : _subService = subService,
        _serviceName = serviceName,
        _subServiceResponse = subServiceResponse,
        super(key: key);

  final String _serviceName;
  final ESubService _subService;
  final SubService _subServiceResponse;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.E_SERVICE,
        //     arguments: {'eService': _subService, 'heroTag': 'service_list_item'});
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${_subService.title.en}"),
              Row(
                children: [
                  // Text("${_subService.price} /",  style: ,),
                  Ui.getPrice(
                    _subService.price,
                    style: Get.textTheme.headline3.merge(TextStyle(fontSize: 14, color: Get.theme.colorScheme.secondary)),
                  ),
                  Text(
                    "  /Unit",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      _addToCartController.findItemInArray(_subService.id, SqfLiteKey.subService) > -1
                          ? Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        _addToCartController.removeFromCart(_subService.id, SqfLiteKey.subService);
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
                                        _addToCartController.decrement(_subService.id, SqfLiteKey.subService, _subService.minimumUnit);
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
                                    child: Text("${_addToCartController.addToCartData[_addToCartController.findItemInArray(_subService.id, SqfLiteKey.subService)].added_unit}"),
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
                                          _addToCartController.increment(_subService.id, SqfLiteKey.subService, _subService.minimumUnit);
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
                          : GestureDetector(
                              onTap: () {
                                print("djfjsanfd Cheking _subServiceResponse.media  ${_subServiceResponse.data.media.toString()}");
                                // addToCart(_addToCartController);

                                _addToCartController.insertToCart(AddToCart(type: SqfLiteKey.subService, service_name: _serviceName, service_id: _subService.id, name: _subService.title.en, image_url: _subServiceResponse.data.media != null && _subServiceResponse.data.media.length > 0 ? _subServiceResponse.data.media[0].url : "", price: "${_subService.price}", minimum_unit: "${_subService.minimumUnit}", added_unit: "${_subService.minimumUnit < 1 ? 1 : _subService.minimumUnit}"));
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
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
