import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/e_service/widgets/sub_service_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/service__details_controller.dart';

class SubServiceListWidget extends GetView<ServiceDetailsController> {
  SubServiceListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var subServiceList = controller.serviceDetails.value.data[0].options;
      var serviceName = controller.serviceDetails.value.data[0].name.en;
      var imageUrl = controller.serviceDetails.value.data[0].media != null && controller.serviceDetails.value.data[0].media.length > 0? controller.serviceDetails.value.data[0].media[0].url :"";

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
            return SubServiceListItemWidget(subService: _subService, serviceName:  serviceName, imageUrl:  imageUrl,);
          }),
        );
      }
    });
  }
}
