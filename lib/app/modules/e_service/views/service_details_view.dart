// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:home_services/app/modules/e_service/widgets/service_list_widget.dart';
// import 'package:home_services/app/modules/e_service/widgets/sub_service_list_widget.dart';
// import '../../../../common/keywords_helper.dart';
// import '../../../../common/sqf_lite_key.dart';
// import '../../../../common/ui.dart';
// import '../../../models/add_to_cart_model.dart';
// import '../../../models/service_details_model.dart';
// // import '../../../models/service_model.dart';
// import '../../../providers/laravel_provider.dart';
// import '../../../routes/app_routes.dart';
// import '../../cart/controller/add_to_cart_controller.dart';
// import '../../global_widgets/circular_loading_widget.dart';
// import '../../global_widgets/tab_bar_widget.dart';
// import '../controllers/service__details_controller.dart';
// import '../controllers/service_controller.dart';
// import '../widgets/e_service_title_bar_widget.dart';
//
// class ServiceDetailsView extends GetView<ServiceDetailsController> {
//   final AddToCartController _addToCartController =
//       Get.put(AddToCartController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       var _serviceDetails = controller.serviceDetails.value;
//       print("fsjfsads0001 ${_serviceDetails.toString()}");
//       if (_serviceDetails.data == null) {
//         print("fsjfsads0002");
//         return Scaffold(
//           body: CircularLoadingWidget(height: Get.height),
//         );
//       } else {
//         print("fsjfsads0003");
//
//         return Scaffold(
//           body: RefreshIndicator(
//               onRefresh: () async {
//                 Get.find<LaravelApiClient>().forceRefresh();
//                 controller.refreshEService(showMessage: true);
//                 Get.find<LaravelApiClient>().unForceRefresh();
//               },
//               child: CustomScrollView(
//                 primary: true,
//                 shrinkWrap: false,
//                 slivers: <Widget>[
//                   SliverAppBar(
//                     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                     expandedHeight: 310,
//                     elevation: 0,
//                     floating: true,
//                     iconTheme:
//                         IconThemeData(color: Theme.of(context).primaryColor),
//                     centerTitle: true,
//                     automaticallyImplyLeading: false,
//                     leading: new IconButton(
//                       icon: Container(
//                         decoration:
//                             BoxDecoration(shape: BoxShape.circle, boxShadow: [
//                           BoxShadow(
//                             color: Get.theme.primaryColor.withOpacity(0.5),
//                             blurRadius: 20,
//                           ),
//                         ]),
//                         child: new Icon(Icons.arrow_back_ios,
//                             color: Get.theme.hintColor),
//                       ),
//                       onPressed: () => {Get.back()},
//                     ),
//                     bottom: buildEServiceTitleBarWidget(_serviceDetails),
//                     flexibleSpace: FlexibleSpaceBar(
//                       collapseMode: CollapseMode.parallax,
//                       // background: Obx(() {
//                       //   return Stack(
//                       //     alignment: AlignmentDirectional.bottomCenter,
//                       //     children: <Widget>[
//                       //       buildCarouselSlider(_service),
//                       //       buildCarouselBullets(_service),
//                       //     ],
//                       //   );
//                       // }),
//                       background: Stack(
//                         alignment: AlignmentDirectional.bottomCenter,
//                         children: <Widget>[
//                           buildCarouselSlider(_serviceDetails),
//                           buildCarouselBullets(_serviceDetails),
//                         ],
//                       ),
//                     ).marginOnly(bottom: 50),
//                   ),
//
//                   // WelcomeWidget(),
//                   SliverToBoxAdapter(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(
//                           height: 15,
//                         ),
//                         TabBarWidget(
//                           tag: 'test1',
//                           initialSelectedId: 0,
//                           tabs: List.generate(controller.tabs.length, (index) {
//                             print("tabs ${controller.tabs.length}");
//                             var tabName = controller.tabs.elementAt(index);
//                             return ChipWidget(
//                               tag: 'test1',
//                               text: tabName,
//                               id: index,
//                               onSelected: (id) {
//                                 controller.changeTab(id);
//                               },
//                             );
//                           }),
//                         ),
//                         // SizedBox(height: 5,),
//                         if (controller.selectedTab == 0)
//                           Container(
//                             child: SubServiceListWidget(),
//                             // child: Container(),
//                           ),
//                         if (controller.selectedTab == 1)
//                           Container(
//                             padding: EdgeInsets.only(
//                                 top: 10, left: 10, bottom: 10, right: 10),
//                             child: Ui.applyHtml(
//                                 _serviceDetails.data[0].description != null? _serviceDetails.data[0].description.en: "",
//                                 style: Get.textTheme.bodyText1),
//                           ),
//                         if (controller.selectedTab == 2)
//                           Container(
//                             padding: EdgeInsets.only(
//                                 top: 10, left: 10, bottom: 10, right: 10),
//                             child: Ui.applyHtml(
//                                 _serviceDetails.data[0].faq != null ? _serviceDetails.data[0].faq.en : "",
//                                 style: Get.textTheme.bodyText1),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//           bottomNavigationBar: Container(
//               padding: EdgeInsets.only(left: 15, right: 15),
//               height: 50,
//               // color: Colors.white,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 // borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   // BoxShadow(
//                   //   color: Colors.grey.shade900,
//                   //   blurRadius: 4,
//                   //   offset: Offset(4, 8), // Shadow position
//                   // ),
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 5,
//                     blurRadius: 7,
//                     offset: Offset(0, 3), // changes position of shadow
//                   ),
//                 ],
//               ),
//               child: InkWell(
//                 onTap: (){
//                   Get.toNamed(Routes.CART);
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "${_addToCartController.addToCartData.length} ${_addToCartController.addToCartData.length > 1 ? "Services".tr : "Service".tr}",
//                           style:TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w100),
//                         ),
//                         Text(
//                           " | ",
//                             style: TextStyle(fontSize: 20, color: Colors.grey.shade500, fontWeight: FontWeight.normal),
//                         ),
//                         Text(
//                           "${_addToCartController.totalAmount().toStringAsFixed(3)}",
//                           style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w100),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(
//                           left: 20, right: 20, top: 10, bottom: 10),
//                       decoration: BoxDecoration(
//                         color: Get.theme.colorScheme.secondary,
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           Get.toNamed(Routes.CART);
//                         },
//                         child: Text("Confirm".tr,
//                             style: (TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white))),
//                       ),
//                     )
//                   ],
//                 ),
//               )),
//         );
//       }
//     });
//   }
//
//   CarouselSlider buildCarouselSlider(ServiceDetails _serviceDetails) {
//     print("fsjfsads images.. ${_serviceDetails.data[0].media.toString()}");
//     if (_serviceDetails.data[0].media.length < 1) {
//       _serviceDetails.data[0].media.add(Media(url: KeywordsHelper.noImageUrl));
//     }
//     return CarouselSlider(
//       options: CarouselOptions(
//         autoPlay: true,
//         autoPlayInterval: Duration(seconds: 7),
//         height: 370,
//         viewportFraction: 1.0,
//         onPageChanged: (index, reason) {
//           controller.currentSlide.value = index;
//         },
//       ),
//       items: _serviceDetails.data[0].media.map((Media media) {
//         print("fsjfsads image  ${media.url}");
//
//         return Builder(
//           builder: (BuildContext context) {
//             return Hero(
//               tag: "test",
//               child: CachedNetworkImage(
//                 width: double.infinity,
//                 height: 350,
//                 fit: BoxFit.cover,
//                 imageUrl: media.url,
//                 placeholder: (context, url) => Image.asset(
//                   'assets/img/loading.gif',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//                 errorWidget: (context, url, error) => Icon(Icons.error_outline),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
//
//
//   Container buildCarouselBullets(ServiceDetails _serviceDetails) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: _serviceDetails.data[0].media.map((Media media) {
//           return Container(
//             width: 20.0,
//             height: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 color: controller.currentSlide.value ==
//                     _serviceDetails.data[0].media.indexOf(media)
//                     ? Get.theme.hintColor
//                     : Get.theme.primaryColor.withOpacity(0.4)),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   EServiceTitleBarWidget buildEServiceTitleBarWidget(ServiceDetails _serviceDetails) {
//     print("skdmfnasjd ${_serviceDetails.data[0].price}");
//     return EServiceTitleBarWidget(
//       additionalHeight: !_serviceDetails.data[0].hasSubType? 16.00: 0.00,
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   _serviceDetails.data[0].name.en ?? '',
//                   style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
//                   maxLines: 2,
//                   softWrap: true,
//                   overflow: TextOverflow.fade,
//                 ),
//               ),
//             ],
//           ),
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: Wrap(
//           //         crossAxisAlignment: WrapCrossAlignment.end,
//           //         children:
//           //             List.from(Ui.getStarsList((_serviceDetails.data[0].rate)))
//           //               ..addAll([
//           //                 SizedBox(width: 10),
//           //                 Text(
//           //                   "Reviews (%s)"
//           //                       .trArgs(["${_serviceDetails.data[0].rate}"]),
//           //                   style: Get.textTheme.caption
//           //                       .merge(TextStyle(fontSize: 12)),
//           //                 ),
//           //               ]),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           _serviceDetails.data[0].price != null && _serviceDetails.data[0].price > 0
//               ? Row(
//                   children: [
//                     Text("Price ",
//                         style: Get.textTheme.caption
//                             .merge(TextStyle(fontSize: 12))),
//                     Ui.getPrice(
//                       _serviceDetails.data[0].price,
//                       style: Get.textTheme.headline3.merge(TextStyle(
//                           fontSize: 14,
//                           color: Get.theme.colorScheme.secondary)),
//                     )
//                   ],
//                 )
//               : Row(
//                   children: [
//                     Text("Starts from ",
//                         style: Get.textTheme.caption
//                             .merge(TextStyle(fontSize: 12))),
//                     Ui.getPrice(
//                       double.parse("${_serviceDetails.data[0].minPrice}") ,
//                       style: Get.textTheme.headline3.merge(TextStyle(
//                           fontSize: 14,
//                           color: Get.theme.colorScheme.secondary)),
//                     )
//                   ],
//                 ),
//           !_serviceDetails.data[0].hasSubType?
//           Container(
//             padding: EdgeInsets.only(top: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // Container(padding: EdgeInsets.only(left: 15), child: Text("View Details".tr, style: Get.textTheme.headline3.merge(TextStyle(fontSize: 14, color: Get.theme.colorScheme.secondary)))),
//                 _addToCartController.findItemInArray(_serviceDetails.data[0].id, SqfLiteKey.service) > -1
//                     ? Container(
//                   child: Row(
//                     children: [
//                       Container(
//                         child: InkWell(
//                           onTap: () {
//                             _addToCartController.removeFromCart(_serviceDetails.data[0].id, SqfLiteKey.service);
//                           },
//                           child: Icon(
//                             Icons.delete_forever_outlined,
//                             color: Get.theme.colorScheme.secondary,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Get.theme.colorScheme.secondary,
//                           borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
//                         ),
//                         child: InkWell(
//                           onTap: () {
//                             // _addToCartController.removeFromCart(_service.id, SqfLiteKey.service);
//                             _addToCartController.decrement(_serviceDetails.data[0].id, SqfLiteKey.service, _serviceDetails.data[0].minimumUnit);
//                           },
//                           child: Padding(
//                               padding: EdgeInsets.only(left: 5, right: 5),
//                               child: Icon(
//                                 Icons.remove,
//                                 color: Colors.white,
//                               )),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           color: Get.theme.colorScheme.secondary.withOpacity(.1),
//                           // borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
//                         ),
//                         child: Text("${_addToCartController.addToCartData[_addToCartController.findItemInArray(_serviceDetails.data[0].id, SqfLiteKey.service)].added_unit}"),
//                       ),
//                       Container(
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Get.theme.colorScheme.secondary,
//                           borderRadius: BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
//                         ),
//                         child: InkWell(
//                             onTap: () {
//                               // addToCart(_addToCartController);
//                               _addToCartController.increment(_serviceDetails.data[0].id, SqfLiteKey.service, _serviceDetails.data[0].minimumUnit);
//                             },
//                             child: Padding(
//                                 padding: EdgeInsets.only(left: 5, right: 5),
//                                 child: Icon(
//                                   Icons.add,
//                                   color: Colors.white,
//                                 ))),
//                       ),
//                     ],
//                   ),
//                   // child: Text("item ${_addToCartController.findItemInArray(_service.id) >-1? _addToCartController.addToCartData[_addToCartController.findItemInArray(_service.id)].added_unit : 1}"),
//                 )
//                     : _serviceDetails.data[0].hasSubType != true
//                     ? GestureDetector(
//                   onTap: () {
//                     print("djfjsanfd Cheking data");
//                     // addToCart(_addToCartController);
//
//                     _addToCartController.insertToCart(AddToCart(type: SqfLiteKey.service, service_name: _serviceDetails.data[0].name.en, service_id: _serviceDetails.data[0].id, name: _serviceDetails.data[0].name.en, image_url: _serviceDetails.data[0].media != null && _serviceDetails.data[0].media.length > 0 ? _serviceDetails.data[0].media[0].url : "", price: "${_serviceDetails.data[0].price}", discount_price: "${_serviceDetails.data[0].discountPrice}", minimum_unit: "${_serviceDetails.data[0].minimumUnit}", added_unit: "${_serviceDetails.data[0].minimumUnit < 1 ? 1 : _serviceDetails.data[0].minimumUnit}"));
//                   },
//                   child: Container(
//                     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//                     decoration: BoxDecoration(
//                       color: Get.theme.colorScheme.secondary,
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     child: Text("Add".tr, style: (TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
//                   ),
//                 )
//
//                     : GestureDetector(
//                   onTap: () {
//                     print("gugyu ${_serviceDetails.data[0].id}");
//                     Get.toNamed(Routes.SUB_SERVICE, arguments: {'heroTag': 'test', 'service_id': _serviceDetails.data[0].id});
//                   },
//                   child: Container(
//                     padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//                     decoration: BoxDecoration(
//                       color: Get.theme.colorScheme.secondary,
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     child: Text("See options".tr, style: (TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
//                   ),
//                 )
//               ],
//             ),
//           ): SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }



import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:home_services/app/modules/e_service/widgets/service_list_widget.dart'; // No longer needed
// import 'package:home_services/app/modules/e_service/widgets/sub_service_list_widget.dart'; // No longer needed
import '../../../../common/keywords_helper.dart';
import '../../../../common/sqf_lite_key.dart';
import '../../../../common/ui.dart';
import '../../../models/add_to_cart_model.dart';
import '../../../models/service_details_model.dart';
// import '../../../models/service_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../global_widgets/circular_loading_widget.dart';
// import '../../global_widgets/tab_bar_widget.dart'; // No longer needed
import '../controllers/service__details_controller.dart';
// import '../controllers/service_controller.dart'; // No longer needed
import '../widgets/e_service_title_bar_widget.dart';

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  final AddToCartController _addToCartController =
  Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _serviceDetails = controller.serviceDetails.value;
      print("fsjfsads0001 ${_serviceDetails.toString()}");
      if (_serviceDetails.data == null) {
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme:
                    IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios,
                            color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildEServiceTitleBarWidget(_serviceDetails),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          buildCarouselSlider(_serviceDetails),
                          buildCarouselBullets(_serviceDetails),
                        ],
                      ),
                    ).marginOnly(bottom: 50),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 15,
                        ),

                        // MODIFIED: Replaced TabBarWidget with a simple static title.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Text(
                            "Service Included".tr,
                            style: Get.textTheme.headlineSmall,
                          ),
                        ),

                        // MODIFIED: Removed all `if` conditions and other tab content.
                        // Only the "Description" content is shown now.
                        Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, bottom: 10, right: 20),
                          child: Ui.applyHtml(
                              _serviceDetails.data[0].description != null? _serviceDetails.data[0].description.en: "",
                              style: Get.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          bottomNavigationBar: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: InkWell(
                onTap: (){
                  Get.toNamed(Routes.CART);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${_addToCartController.addToCartData.length} ${_addToCartController.addToCartData.length > 1 ? "Services".tr : "Service".tr}",
                          style:TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w100),
                        ),
                        Text(
                          " | ",
                          style: TextStyle(fontSize: 20, color: Colors.grey.shade500, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "${_addToCartController.totalAmount().toStringAsFixed(3)}",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w100),
                        ),
                      ],
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
                ),
              )),
        );
      }
    });
  }

  CarouselSlider buildCarouselSlider(ServiceDetails _serviceDetails) {
    print("fsjfsads images.. ${_serviceDetails.data[0].media.toString()}");
    if (_serviceDetails.data[0].media.length < 1) {
      _serviceDetails.data[0].media.add(Media(url: KeywordsHelper.noImageUrl));
    }
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _serviceDetails.data[0].media.map((Media media) {
        print("fsjfsads image  ${media.url}");

        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: "test",
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }


  Container buildCarouselBullets(ServiceDetails _serviceDetails) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _serviceDetails.data[0].media.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value ==
                    _serviceDetails.data[0].media.indexOf(media)
                    ? Get.theme.hintColor
                    : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(ServiceDetails _serviceDetails) {
    print("skdmfnasjd ${_serviceDetails.data[0].price}");
    return EServiceTitleBarWidget(
      additionalHeight: !_serviceDetails.data[0].hasSubType? 16.00: 0.00,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _serviceDetails.data[0].name.en ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          _serviceDetails.data[0].price != null && _serviceDetails.data[0].price > 0
              ? Row(
            children: [
              Text("Price ".tr,
                  style: Get.textTheme.caption
                      .merge(TextStyle(fontSize: 12))),
              Ui.getPrice(
                _serviceDetails.data[0].price,
                style: Get.textTheme.headline3.merge(TextStyle(
                    fontSize: 14,
                    color: Get.theme.colorScheme.secondary)),
              )
            ],
          )
              : Row(
            children: [
              Text("Starts from ".tr,
                  style: Get.textTheme.caption
                      .merge(TextStyle(fontSize: 12))),
              Ui.getPrice(
                double.parse("${_serviceDetails.data[0].minPrice}") ,
                style: Get.textTheme.headline3.merge(TextStyle(
                    fontSize: 14,
                    color: Get.theme.colorScheme.secondary)),
              )
            ],
          ),
          !_serviceDetails.data[0].hasSubType?
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _addToCartController.findItemInArray(_serviceDetails.data[0].id, SqfLiteKey.service) > -1
                    ? Container(
                  child: Row(
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            _addToCartController.removeFromCart(_serviceDetails.data[0].id, SqfLiteKey.service);
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
                            _addToCartController.decrement(_serviceDetails.data[0].id, SqfLiteKey.service, _serviceDetails.data[0].minimumUnit);
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
                        ),
                        child: Text("${_addToCartController.addToCartData[_addToCartController.findItemInArray(_serviceDetails.data[0].id, SqfLiteKey.service)].added_unit}"),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.secondary,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
                        ),
                        child: InkWell(
                            onTap: () {
                              _addToCartController.increment(_serviceDetails.data[0].id, SqfLiteKey.service, _serviceDetails.data[0].minimumUnit);
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
                )
                    : _serviceDetails.data[0].hasSubType != true
                    ? GestureDetector(
                  onTap: () {
                    print("djfjsanfd Cheking data");

                    _addToCartController.insertToCart(AddToCart(type: SqfLiteKey.service, service_name: _serviceDetails.data[0].name.en, service_id: _serviceDetails.data[0].id, name: _serviceDetails.data[0].name.en, image_url: _serviceDetails.data[0].media != null && _serviceDetails.data[0].media.length > 0 ? _serviceDetails.data[0].media[0].url : "", price: "${_serviceDetails.data[0].price}", discount_price: "${_serviceDetails.data[0].discountPrice}", minimum_unit: "${_serviceDetails.data[0].minimumUnit}", added_unit: "${_serviceDetails.data[0].minimumUnit < 1 ? 1 : _serviceDetails.data[0].minimumUnit}"));
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
                    print("gugyu ${_serviceDetails.data[0].id}");
                    Get.toNamed(Routes.SUB_SERVICE, arguments: {'heroTag': 'test', 'service_id': _serviceDetails.data[0].id});
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
          ): SizedBox.shrink(),
        ],
      ),
    );
  }
}