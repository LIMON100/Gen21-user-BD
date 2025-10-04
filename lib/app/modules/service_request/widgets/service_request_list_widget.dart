import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/service_request/widgets/service_request_list_item_widget.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/RequestController.dart';
import '../controllers/ServiceRequestController.dart';

class ServiceRequestsListWidget extends GetView<ServiceRequestController> {
  // final RequestController _requestController = Get.put(RequestController());

  ServiceRequestsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("jdfafjdsfsd in ServiceRequestsListWidget build");

      print("jdfafjdsfsd data: ${controller.orderRequestResponse.value.toString()}");
      if (controller.orderRequestResponse.value == null) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.orderRequestResponse.value.eventData.service.length,
          itemBuilder: ((_, index) {
            // var _service = controller.orderedServiceList.elementAt(index);
            return ServiceRequestListItemWidget(index: index);
          }),
        );
      }
    });
  }
}
