import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../models/order_request_response_model.dart';
import '../../home/controllers/home_controller.dart';
// import '../controllers/RequestController.dart';
import 'package:home_services/app/modules/service_request/controllers/RequestController.dart';
import '../controllers/ServiceRequestController.dart';
import '../widgets/service_request_list_widget.dart';
import '../../bookings/controllers/booking_controller_new.dart';

class ServiceRequestsView extends GetWidget<ServiceRequestController> {
  // var isLoading = false.obs;
  // String enteredText = Get.find<RequestController>().noteEditingController.text;
  final bkn = BookingControllerNew();
  RequestController _requestController;
  @override
  Widget build(BuildContext context) {
    print(controller.orderRequestResponse.value.eventData.orderId);
    Service _service = controller.orderRequestResponse.value.eventData.service[0];
    print("CONTROOOOO");
    print(_service);

    // final RequestController _requestController = Get.put(RequestController());
    _requestController = Get.put(RequestController());
    String enteredText = _requestController.noteEditingController.text;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${controller.orderRequestResponse.value.eventData.service.length} Service Requests".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  LinearProgressIndicator(
                    backgroundColor: Colors.red,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  Container(
                    // alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child:Text("Please wait, providers will receive requests soon.", textAlign: TextAlign.center, style: TextStyle(color: Get.theme.colorScheme.secondary, fontSize: 16, ))
                  ),
                  Obx(() {
                    // printWrapped("hhfasjfhbdjas in requestView ${controller.orderRequestPush.value.data.toString()}");
                    return controller.orderRequestResponse.value.eventData.coupon_data != null
                        ? Container(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Applied Coupon: "), Text("${controller.orderRequestResponse.value.eventData.coupon_data.code}")],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Discount: "), controller.orderRequestResponse.value.eventData.coupon_data.discountType.toString() == "percent" ? Text("${controller.orderRequestResponse.value.eventData.coupon_data.discount}%") : Text("\$${controller.orderRequestResponse.value.eventData.coupon_data.discount}")],
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container();
                  }),

                  // Make it OFF for testing
                  // Container(
                  //   child: ServiceRequestsListWidget(),
                  //   // child: Container(),
                  // ),

                  // Container(
                  //   color: Get.theme.colorScheme.secondary,
                  //   height: 40,
                  //   child: Text(enteredText),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
      // Previous stop request
      // bottomNavigationBar: Container(
      //   height: 50,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Obx(() {
      //       return controller.isLoading.value?
      //       Container(margin: EdgeInsets.only(right: 20, bottom: 10), child: CircularProgressIndicator(strokeWidth: 2))
      //           : GestureDetector(onTap: () async{
      //         controller.cancelOrder("${controller.orderRequestResponse.value.eventData.orderId}");
      //       }, child: Container(margin: EdgeInsets.only(right: 20, bottom: 10), padding: EdgeInsets.all(5), child: Text("Stop Request", style: TextStyle(color: Colors.grey),)));
      //     })
      //    ,
      //   ],
      //   ),
      // ),

      // bottomNavigationBar: Container(
      //   height: 50,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Obx(() {
      //       return controller.isLoading.value?
      //       Container(margin: EdgeInsets.only(right: 20, bottom: 10), child: CircularProgressIndicator(strokeWidth: 2))
      //           : GestureDetector(onTap: () async{
      //             bkn.stopBookingService();
      //             // Get.back();
      //         // controller.cancelOrder("${controller.orderRequestResponse.value.eventData.orderId}");
      //       }, child: Container(margin: EdgeInsets.only(right: 20, bottom: 10), padding: EdgeInsets.all(5), child: Text("Cancel Request", style: TextStyle(color: Colors.grey),)));
      //     })
      //    ,
      //   ],
      //   ),
      // ),
    );
  }

// @override
// void dispose() {
//   controller.closeRingTone();
//   super.dispose();
// }

}
