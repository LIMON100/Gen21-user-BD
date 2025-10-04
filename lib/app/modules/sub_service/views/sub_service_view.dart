import 'dart:developer';
import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/e_service/widgets/service_list_widget.dart';
import '../../../../common/ui.dart';
import '../../../models/service_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controller/sub_service_controller.dart';
import '../widgets/sub_service_list_widget.dart';

class SubServiceView extends GetView<SubServiceController> {
  final AddToCartController _addToCartController =
      Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    return Obx(()
    {
      var _subService = controller.subService.value;
      print("fsjfsads0001 ${_subService.toString()}");
      if (_subService.data == null) {
        print("fsjfsads0002");
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        print("fsjfsads0003");

        return Scaffold(
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEService(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: GestureDetector(
                      onTap: ()=> {Get.back()},
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
                        '${_subService.data.name.en}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    // backgroundColor: scrolled ? Colors.blue : Colors.red,
                    pinned: true,
                  ),

                  // SliverAppBar(
                  //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  //   expandedHeight: 50,
                  //   elevation: 0,
                  //   floating: true,
                  //   iconTheme:
                  //       IconThemeData(color: Theme.of(context).primaryColor),
                  //   centerTitle: true,
                  //   automaticallyImplyLeading: false,
                  //   leading: new IconButton(
                  //     icon: Container(
                  //       decoration:
                  //           BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  //         BoxShadow(
                  //           color: Get.theme.primaryColor.withOpacity(0.5),
                  //           blurRadius: 20,
                  //         ),
                  //       ]),
                  //       child: new Icon(Icons.arrow_back_ios,
                  //           color: Get.theme.hintColor),
                  //     ),
                  //     onPressed: () => {Get.back()},
                  //   ),
                  //   // title: Text("Select Subtype"),
                  //   // bottom: buildEServiceTitleBarWidget(_service),
                  //   flexibleSpace: FlexibleSpaceBar(
                  //     collapseMode: CollapseMode.parallax,
                  //     title: Text('Select Subtype', textScaleFactor: 1),
                  //     // background: Obx(() {
                  //     //   return Stack(
                  //     //     alignment: AlignmentDirectional.bottomCenter,
                  //     //     children: <Widget>[
                  //     //       Container(),
                  //     //       buildCarouselSlider(_service),
                  //     //       buildCarouselBullets(_service),
                  //     //     ],
                  //     //   );
                  //     // }),
                  //   ).marginOnly(bottom: 50),
                  // ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Ui.applyHtml(_subService.data.subtypeHeading??"",
                              fontSize: 16,
                              style: Get.textTheme.caption
                                  .merge(TextStyle(height: 1.2))),
                        ),
                        Container(
                          child: SubServiceListWidget(),
                          // child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.CART);
                    },
                    child: Row(
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
                          "${_addToCartController.totalAmount().toStringAsFixed(3)}",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.CART);
                      },
                      child: Text("Confirm".tr,
                          style: (TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                    ),
                  )
                ],
              )),
        );
      }
    });
  }
}
