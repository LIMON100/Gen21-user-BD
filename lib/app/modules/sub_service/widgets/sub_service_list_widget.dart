import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/sub_service/widgets/sub_service_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controller/sub_service_controller.dart';

class SubServiceListWidget extends GetView<SubServiceController> {
  SubServiceListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var subServiceList = controller.subService.value.data.eSubService;
      var serviceName = controller.subService.value.data.name.en;

      if (subServiceList.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: subServiceList.length,
          itemBuilder: ((_, index) {
            var _subService = subServiceList.elementAt(index);
            return SubServiceListItemWidget(subServiceResponse: controller.subService.value,
                serviceName: serviceName, subService: _subService);
          }),
        );
      }
    });
  }
}
