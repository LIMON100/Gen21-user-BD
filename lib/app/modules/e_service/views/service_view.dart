// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:home_services/app/modules/e_service/widgets/service_list_widget.dart';
// import '../../../../common/keywords_helper.dart';
// import '../../../../common/ui.dart';
// import '../../../models/coupon_model.dart';
// import '../../../models/service_model.dart';
// import '../../../providers/laravel_provider.dart';
// import '../../../routes/app_routes.dart';
// import '../../cart/controller/add_to_cart_controller.dart';
// import '../../global_widgets/circular_loading_widget.dart';
// import '../../global_widgets/tab_bar_widget.dart';
// import '../controllers/service_controller.dart';
// import '../widgets/e_service_title_bar_widget.dart';
//
// class ServiceView extends GetView<ServiceController> {
//   final AddToCartController _addToCartController =
//       Get.put(AddToCartController());
//
//   String serviceName = '';
//   bool boxVisible = true;
//   List<Coupon> fetchedCoupons = [];
//   int cc = 0;
//
//   void onBoxClick() {
//     boxVisible = false;
//   }
//
//   bool isCouponExpired(DateTime expiresAt) {
//     return DateTime.now().isAfter(expiresAt);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Obx(() {
//       var _service = controller.service.value;
//       print("fsjfsads0001 ${_service.toString()}");
//       // print(_service.data.name.en);
//       if (_service.data == null) {
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
//                 controller.tryCoupon() as List<Coupon>;
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
//                     bottom: buildEServiceTitleBarWidget(_service),
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
//                           buildCarouselSlider(_service),
//                           buildCarouselBullets(_service),
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
//                         SizedBox(height: 5,),
//
//                         // Showing COUPONS list
//                         if(_service.data.name.en == "CAR SERVICE" )
//                           for (Coupon coupon in controller.newCouponList)
//                             if (!isCouponExpired(DateTime.parse(coupon.expires_at)))
//                               Center(
//                                 child: boxVisible
//                                 ? GestureDetector(
//                                 onTap: onBoxClick,
//                                   child: Container(
//                                     padding: EdgeInsets.all(2.0),
//                                     decoration: BoxDecoration(
//                                       color: Colors.orange,
//                                       borderRadius: BorderRadius.circular(15.0),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           'Coupons',
//                                           style: TextStyle(fontSize: 20, color: Colors.white),
//                                         ),
//                                         SizedBox(height: 10),
//                                         SingleChildScrollView(
//                                           scrollDirection: Axis.horizontal,
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               SizedBox(height: 8),
//                                               for (Coupon coupon in controller.newCouponList)
//                                                 if (!isCouponExpired(DateTime.parse(coupon.expires_at)))
//                                                   Container(
//                                                     margin: EdgeInsets.only(right: 16.0), // Adjust the right margin for spacing
//                                                     padding: EdgeInsets.all(8.0),
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius: BorderRadius.circular(5.0),
//                                                     ),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text('Code: ${coupon.code}'),
//                                                         Text('Discount: ${coupon.discount}%'),
//                                                       ],
//                                                     ),
//                                                   ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                                   : Text(
//                               'Coupon collected successfully. Please apply at booking time.',
//                               style: TextStyle(fontSize: 10),
//                               ),
//                               ),
//                           // Center(
//                           //   child: boxVisible
//                           //       ? GestureDetector(
//                           //     onTap: onBoxClick,
//                           //     child: Container(
//                           //       padding: EdgeInsets.all(2.0),
//                           //       decoration: BoxDecoration(
//                           //         color: Colors.orange,
//                           //         borderRadius: BorderRadius.circular(15.0),
//                           //       ),
//                           //       child: Column(
//                           //         children: [
//                           //           Text(
//                           //             'Coupons',
//                           //             style: TextStyle(fontSize: 20, color: Colors.white),
//                           //           ),
//                           //           SizedBox(height: 10),
//                           //           SingleChildScrollView(
//                           //             scrollDirection: Axis.horizontal,
//                           //             child: Row(
//                           //               mainAxisSize: MainAxisSize.min,
//                           //               children: [
//                           //                 SizedBox(height: 8),
//                           //                 for (Coupon coupon in controller.newCouponList)
//                           //                   Container(
//                           //                     margin: EdgeInsets.only(right: 16.0), // Adjust the right margin for spacing
//                           //                     padding: EdgeInsets.all(8.0),
//                           //                     decoration: BoxDecoration(
//                           //                       color: Colors.white,
//                           //                       borderRadius: BorderRadius.circular(5.0),
//                           //                     ),
//                           //                     child: Column(
//                           //                       crossAxisAlignment: CrossAxisAlignment.start,
//                           //                       children: [
//                           //                         Text('Code: ${coupon.code}'),
//                           //                         Text('Discount: ${coupon.discount}%'),
//                           //
//                           //                       ],
//                           //                     ),
//                           //                   ),
//                           //               ],
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   )
//                           //       : Text(
//                           //     'Coupon collected successfully. Please apply at booking time.',
//                           //     style: TextStyle(fontSize: 10),
//                           //   ),
//                           // ),
//
//
//
//                         SizedBox(height: 20),
//                         if (controller.selectedTab.value == 0)
//                           Container(
//                             child: ServiceListWidget(),
//                             // child: Container(),
//                           ),
//                         if (controller.selectedTab.value == 1)
//                           Container(
//                             padding: EdgeInsets.only(
//                                 top: 10, left: 10, bottom: 10, right: 10),
//                             child: Ui.applyHtml(
//                                 controller.service.value.data.description.en,
//                                 style: Get.textTheme.bodyText1),
//                           ),
//                         if (controller.selectedTab.value == 2)
//                           Container(
//                             padding: EdgeInsets.only(
//                                 top: 10, left: 10, bottom: 10, right: 10),
//                             child: Ui.applyHtml(
//                                 controller.service.value.data.faq,
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
//   CarouselSlider buildCarouselSlider(GService _service) {
//     print("fsjfsads images.. ${_service.data.media.toString()}");
//     if (_service.data.media.length < 1) {
//       _service.data.media.add(Media(url: KeywordsHelper.noImageUrl));
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
//       items: _service.data.media.map((Media media) {
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
//   Container buildCarouselBullets(GService _service) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: _service.data.media.map((Media media) {
//           return Container(
//             width: 20.0,
//             height: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 color: controller.currentSlide.value ==
//                         _service.data.media.indexOf(media)
//                     ? Get.theme.hintColor
//                     : Get.theme.primaryColor.withOpacity(0.4)),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   EServiceTitleBarWidget buildEServiceTitleBarWidget(GService _service) {
//     print("skdmfnasjd ${_service.data.price}");
//     return EServiceTitleBarWidget(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   _service.data.name.en ?? '',
//                   style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
//                   maxLines: 2,
//                   softWrap: true,
//                   overflow: TextOverflow.fade,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5,),
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: Wrap(
//           //         crossAxisAlignment: WrapCrossAlignment.end,
//           //         children:
//           //             List.from(Ui.getStarsList((_service.data.avgRating)))
//           //               ..addAll([
//           //                 SizedBox(width: 10),
//           //                 Text(
//           //                   "Reviews (%s)"
//           //                       .trArgs(["${_service.data.reviewCount}"]),
//           //                   style: Get.textTheme.caption
//           //                       .merge(TextStyle(fontSize: 12)),
//           //                 ),
//           //               ]),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           _service.data.price != null && _service.data.price > 0
//               ? Row(
//                   children: [
//                     Text("Price ",
//                         style: Get.textTheme.caption
//                             .merge(TextStyle(fontSize: 12))),
//                     Ui.getPrice(
//                       _service.data.price,
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
//                       _service.data.minPrice,
//                       style: Get.textTheme.headline3.merge(TextStyle(
//                           fontSize: 14,
//                           color: Get.theme.colorScheme.secondary)),
//                     )
//                   ],
//                 )
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
import 'package:home_services/app/modules/e_service/widgets/service_list_widget.dart';
import '../../../../common/keywords_helper.dart';
import '../../../../common/ui.dart';
import '../../../models/coupon_model.dart';
import '../../../models/service_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controller/add_to_cart_controller.dart';
import '../../global_widgets/circular_loading_widget.dart';
// REMOVED: Unused TabBarWidget import
// import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/service_controller.dart';
import '../widgets/e_service_title_bar_widget.dart';

class ServiceView extends GetView<ServiceController> {
  final AddToCartController _addToCartController =
  Get.put(AddToCartController());

  String serviceName = '';
  bool boxVisible = true;
  List<Coupon> fetchedCoupons = [];
  int cc = 0;

  void onBoxClick() {
    boxVisible = false;
  }

  bool isCouponExpired(DateTime expiresAt) {
    return DateTime.now().isAfter(expiresAt);
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      var _service = controller.service.value;
      print("fsjfsads0001 ${_service.toString()}");
      // print(_service.data.name.en);
      if (_service.data == null) {
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
                controller.tryCoupon() as List<Coupon>;
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
                    bottom: buildEServiceTitleBarWidget(_service),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          buildCarouselSlider(_service),
                          buildCarouselBullets(_service),
                        ],
                      ),
                    ).marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        // MODIFIED: Replaced TabBarWidget with a centered Text widget
                        Text(
                          "Services".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 5,),

                        // Showing COUPONS list
                        if(_service.data.name.en == "CAR SERVICE" )
                          for (Coupon coupon in controller.newCouponList)
                            if (!isCouponExpired(DateTime.parse(coupon.expires_at)))
                              Center(
                                child: boxVisible
                                    ? GestureDetector(
                                  onTap: onBoxClick,
                                  child: Container(
                                    padding: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Coupons',
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                        SizedBox(height: 10),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 8),
                                              for (Coupon coupon in controller.newCouponList)
                                                if (!isCouponExpired(DateTime.parse(coupon.expires_at)))
                                                  Container(
                                                    margin: EdgeInsets.only(right: 16.0), // Adjust the right margin for spacing
                                                    padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Code: ${coupon.code}'),
                                                        Text('Discount: ${coupon.discount}%'),
                                                      ],
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : Text(
                                  'Coupon collected successfully. Please apply at booking time.',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                        SizedBox(height: 20),

                        // MODIFIED: Removed conditional logic for tabs. ServiceListWidget is now always visible.
                        ServiceListWidget(),
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

  CarouselSlider buildCarouselSlider(GService _service) {
    print("fsjfsads images.. ${_service.data.media.toString()}");
    if (_service.data.media.length < 1) {
      _service.data.media.add(Media(url: KeywordsHelper.noImageUrl));
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
      items: _service.data.media.map((Media media) {
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

  Container buildCarouselBullets(GService _service) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _service.data.media.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value ==
                    _service.data.media.indexOf(media)
                    ? Get.theme.hintColor
                    : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(GService _service) {
    print("skdmfnasjd ${_service.data.price}");
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _service.data.name.en ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          _service.data.price != null && _service.data.price > 0
              ? Row(
            children: [
              Text("Price ",
                  style: Get.textTheme.caption
                      .merge(TextStyle(fontSize: 12))),
              Ui.getPrice(
                _service.data.price,
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
                _service.data.minPrice,
                style: Get.textTheme.headline3.merge(TextStyle(
                    fontSize: 14,
                    color: Get.theme.colorScheme.secondary)),
              )
            ],
          )
        ],
      ),
    );
  }
}