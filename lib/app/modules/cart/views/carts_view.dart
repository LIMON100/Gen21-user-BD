import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../widgets/cart_list_widget.dart';

class CartsView extends GetView<AddToCartController> {
  final AddToCartController _addToCartController =
      Get.put(AddToCartController());

  // Set<String> serviceNames = {};
  // List<String> sn = [];
  // String serviceNamesString = "";
  //
  // Future<void> _fetchServiceName() async {
  //   var addToCardData = _addToCartController.addToCartData;
  //
  //   // Extract unique service names from addToCardData
  //   for (AddToCart item in addToCardData) {
  //     serviceNames.add(item.service_name);
  //     sn.add(item.service_name);
  //   }
  //
  //   print("SERVICEITEMLIST: ");
  //   print(sn.length);
  //
  //   // Convert the Set to a comma-separated string
  //   serviceNamesString = serviceNames.join(', ');
  // }


  @override
  Widget build(BuildContext context) {
    // _fetchServiceName();
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          primary: true,
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              title: Container(
                width: double.infinity,
                alignment: Alignment.topLeft,
                child: Text(
                  'My Cart'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              // backgroundColor: scrolled ? Colors.blue : Colors.red,
              pinned: true,
            ),
            SliverToBoxAdapter(child: Obx(() {
              var padding = MediaQuery.of(context).padding;
              var _carts = controller.addToCartData;
              if (controller.isLoading.value) {
                print("fsjfsads0002");
                return CircularLoadingWidget(
                  height: MediaQuery.of(context).size.height -
                      120 -
                      padding.top -
                      padding.bottom,
                );
              } else if (_carts.isEmpty) {
                return Container(
                    // color: Colors.blue,
                    height: MediaQuery.of(context).size.height -
                        120 -
                        padding.top -
                        padding.bottom,
                    child: Center(
                      child: Text(
                        "Cart list is empty!",
                        style: Get.textTheme.bodyText1.merge(
                          TextStyle(fontSize: 16),
                        ),
                      ),
                    ));
              } else {
                print("fsjfsads0003");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 20, right: 20),
                          child: Text(
                              "${_addToCartController.addToCartData.length} ${_addToCartController.addToCartData.length > 1 ? "items" : "item"} in cart"),
                        ),
                      ],
                    ),
                    Container(
                      child: CartListWidget(),
                      // child: Container(),
                    ),
                  ],
                );
              }
              ;
            })),
          ],
        ),

        // Obx(() {
        //   var _carts = controller.addToCartData;
        //   print("fsjfsads0001 ${_carts.toString()}");
        //   if (controller.isLoading.value) {
        //     print("fsjfsads0002");
        //     return CircularLoadingWidget(height: Get.height);
        //
        //   } else if (_carts.isEmpty) {
        //     return Center(child: Container(height: Get.height, child: Text("Cart list is empty!")));
        //
        //   } else {
        //     print("fsjfsads0003");
        //
        //     return
        //       CustomScrollView(
        //       primary: true,
        //       shrinkWrap: false,
        //       slivers: <Widget>[
        //         SliverAppBar(
        //           leading: GestureDetector(
        //             onTap: () {
        //               Get.back();
        //             },
        //             child: Icon(
        //               Icons.arrow_back_ios,
        //               color: Colors.black,
        //             ),
        //           ),
        //           backgroundColor: Colors.white,
        //           title: Container(
        //             width: double.infinity,
        //             alignment: Alignment.topLeft,
        //             child: Text(
        //               'My Cart'.tr,
        //               style: TextStyle(fontSize: 16, color: Colors.black),
        //             ),
        //           ),
        //           // backgroundColor: scrolled ? Colors.blue : Colors.red,
        //           pinned: true,
        //         ),
        //         SliverToBoxAdapter(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        //               Row(
        //                 children: [
        //                   Container(
        //                     padding: EdgeInsets.only(top: 15, left: 20, right: 20),
        //                     child: Text("${_addToCartController.addToCartData.length} ${_addToCartController.addToCartData.length > 1 ? "items" : "item"} in cart"),
        //                   ),
        //                 ],
        //               ),
        //               Container(
        //                 child: CartListWidget(),
        //                 // child: Container(),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     );
        //
        //   }
        // }),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 50,
          // color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(20),
            boxShadow: [
              // BoxShadow(
              //   color: Colors.grey.shade900,
              //   blurRadius: 4,
              //   offset: Offset(4, 8), // Shadow position
              // ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              // Get.toNamed(Routes.SERVICE_REQUEST);
            },
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "${_addToCartController.addToCartData.length} ${_addToCartController.addToCartData.length > 1 ? "Services".tr : "Service".tr}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w100),
                      ),
                      Text(
                        " | ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "${_addToCartController.totalAmount().toStringAsFixed(3)}\$",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!Get.find<AuthService>().isAuth) {
                        Get.toNamed(Routes.LOGIN);
                      } else if (controller.addToCartData.length > 0) {
                        Get.toNamed(Routes.SERVICE_REQUEST);
                      } else {
                        Get.showSnackbar(Ui.ErrorSnackBar(
                            message: "Your cart list is empty!".tr));
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: controller.addToCartData.length > 0
                            ? Get.theme.colorScheme.secondary
                            : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text("Next".tr,
                          style: (TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                    ),
                  )
                ],
              );
            }),
          )),
    );
  }
}
