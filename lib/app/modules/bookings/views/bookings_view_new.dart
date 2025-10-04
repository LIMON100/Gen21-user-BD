import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/bookings_controller.dart';
import '../controllers/bookings_controllerNew.dart';
import '../widgets/bookings_list_widget.dart';
import '../widgets/bookings_list_widget_new.dart';

class BookingsViewNew extends GetView<BookingsControllerNew> {
  @override
  Widget build(BuildContext context) {
    // Get.put(BookingsControllerNew());
    // controller.initScrollController();
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            // controller.refreshBookings(showMessage: true, statusId: controller.currentStatus.value);
            controller.refreshBookings(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              Obx(() {
                return
                  SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  // expandedHeight: 120,
                  elevation: 0.5,
                  floating: false,
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  title: Text(
                    "Bookings".tr,
                    style: Get.textTheme.headline6,
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.chevron_left, color: Colors.black87, size: 32,),
                    // onPressed: () => {Scaffold.of(context).openDrawer()},
                    onPressed: () => {Get.back()},
                  ),
                  actions: [NotificationsButtonWidget()],

                  bottom: controller.hasPending.value? TabBarWidget(
                    tag: 'bookings',
                    initialSelectedId: 0,
                    tabs: List.generate(controller.tabs.length, (index) {
                      var _tabItem = controller.tabs.elementAt(index);
                      return ChipWidget(
                        tag: 'bookings',
                        text: _tabItem,
                        id: index,
                        onSelected: (id) {
                          controller.changeTab(id);
                        },
                      );
                    }),
                  ) : null


                );
              }),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Container( child:BookingsListWidgetNew(),)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
