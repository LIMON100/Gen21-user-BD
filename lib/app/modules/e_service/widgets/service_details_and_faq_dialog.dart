import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/service_model.dart';
import '../../global_widgets/tab_bar_widget.dart';

class ServiceDatailsAndFaqDialog extends StatefulWidget{
  ServiceDatailsAndFaqDialog({
    Key key,
    @required EServices service,
  })  : service = service,
        super(key: key);
  final EServices service;
  @override
  State<StatefulWidget> createState() {
   return ServiceDetailsAndFaqDialogState();
  }


}
class ServiceDetailsAndFaqDialogState extends State<ServiceDatailsAndFaqDialog>{
  List<String> tabs = ["Description", "Faq"];
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return   Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 10, left: 10, right: 10),
              // child: Text("Description",  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
              child: Text("Service Included",  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.fade,),
            ),

            Container(
              padding: EdgeInsets.only(
                 left: 10, bottom: 10, top: 5, right: 7),
              child: Ui.applyHtml(
                  widget.service?.description?.en ?? "N/A",
                  style: Get.textTheme.bodyText1),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}