import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pusher_channels_flutter/pusher-js/core/pusher.dart';
// import 'package:laravel_echo/laravel_echo.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/carts_button_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../pusher/views/pusher_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {


  @override
  Widget build(BuildContext context) {
    controller.refreshHome2();
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PusherView()),
            // );
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 300,
                elevation: 0.5,
                floating: true,
                // iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Container(child: Image(image: AssetImage("assets/icon/icon.png"), height: 50,)),
                // Text(
                //   Get.find<SettingsService>().setting.value.appName,
                //   style: Get.textTheme.headline6,
                // ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [CartsButtonWidget(), NotificationsButtonWidget()],
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : Ui.getAlignmentDirectional(controller.slider.elementAt(controller.currentSlide.value).textPosition),
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            // print("hyutopuk_1: slide:" + slide.toString());
                            // if (slide.eProvider != null) {
                            //   print("hyutopuk_1: eProvider:" + slide.eProvider.toString());
                            // } else if (slide.eService != null) {
                            //   print("hyutopuk_1: eService:" + slide.eService.toString());
                            // } else if (slide.category != null) {
                            //   print("hyutopuk_1: category:" + slide.category.toString());
                            // }
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value == controller.slider.indexOf(slide) ? slide.indicatorColor : slide.indicatorColor.withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 42),
              ),
              SliverToBoxAdapter(
                child: Obx((){return  Wrap(
                  children: [
                    AddressWidget(),
                    if(controller.categories.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(child: Text("Categories".tr, style: Get.textTheme.headline5)),
                            MaterialButton(
                              onPressed: () {
                                Get.toNamed(Routes.CATEGORIES);
                              },
                              shape: StadiumBorder(),
                              color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                              child: Text("View All".tr, style: Get.textTheme.subtitle1),
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                    if(controller.categories.isNotEmpty)
                      CategoriesCarouselWidget(),
                    if(controller.eServices.isNotEmpty)
                      Container(
                        color: Get.theme.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(child: Text("Recommended for you".tr, style: Get.textTheme.headline5)),
                            // MaterialButton(
                            //   onPressed: () {
                            //     Get.toNamed(Routes.CATEGORIES);
                            //   },
                            //   shape: StadiumBorder(),
                            //   color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            //   child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            //   elevation: 0,
                            // ),
                          ],
                        ),
                      ),
                    if(controller.eServices.isNotEmpty)
                      RecommendedCarouselWidget(),
                    FeaturedCategoriesWidget(),
                  ],
                );}),

              ),
            ],
          )),
    );
  }



}
