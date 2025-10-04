import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/e_service/widgets/service_list_item_widget.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/service_controller.dart';

class ServiceListWidget extends GetView<ServiceController> {
  ServiceListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var serviceList = controller.service.value.data.eServices;

      if (serviceList.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10),

          primary: false,
          shrinkWrap: true,
          itemCount: serviceList.length,
          itemBuilder: ((_, index) {
            // if (index == serviceList.length) {
            //   return Obx(() {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: new Center(
            //         child: new Opacity(
            //           opacity: serviceList.length < 1 ? 1 : 0,
            //           child: new CircularProgressIndicator(),
            //         ),
            //       ),
            //     );
            //   });
            // } else {
              var _service = serviceList.elementAt(index);
              return ServiceListItemWidget(service: _service);
            // }
          }),
        );
      }
    });
  }
}
