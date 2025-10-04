import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';
import '../../global_widgets/search_bar_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/RequestController.dart';

class WelcomeWidgetTest extends GetView<RequestController> {



  @override
  Widget build(BuildContext context) {
    // var data = controller.responseData;
    // print("sdndjfna  Hello Data: ${data.toString()}");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Get.theme.colorScheme.secondary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Welcome,".tr, style: Get.textTheme.bodyText1),
                Text(Get.find<AuthService>().user.value.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor))),
                Text('!', style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor)))
              ],
            ),
            SizedBox(height: 8),
            Text("Can I help you something?".tr, style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
            SizedBox(height: 22),
            SearchBarWidget()
          ],
        ),
      ),
    );
  }
}
