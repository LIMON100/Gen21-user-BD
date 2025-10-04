// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
// import '../../../routes/app_routes.dart';
// import '../../cart/controller/add_to_cart_controller.dart';
// import '../../home/controllers/home_controller.dart';
// import '../controllers/RequestController.dart';
//
// class TestBottomSheetWidget extends GetWidget<RequestController> {
//   @override
//   Widget build(BuildContext context) {
//     final AddToCartController _addToCartController = Get.put(AddToCartController());
//     return  Obx(() {
//       var  requestChannel = controller.requestChannel;
//       var pusherChannelSubscriptionStatus = controller.pusherChannelSubscriptionStatus;
//       print("kwnnasf requestChannel ${requestChannel.toString()} pusher: ${pusherChannelSubscriptionStatus.value.toString()}");
//       return  Container(
//         height: 200,
//         color: Colors.white,
//         child: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
//                 width: double.infinity,
//                 color: Get.theme.colorScheme.secondary,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     pusherChannelSubscriptionStatus.value.toLowerCase() == "true"
//                         ? Text("Waiting for providers response!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
//                         : pusherChannelSubscriptionStatus == ""
//                         ? Text("Searching for providers", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
//                         : Text("Something went wrong!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
//
//                     // SizedBox(
//                     //   height: 3,
//                     // ),
//                     // Text("Please wait a while", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w100))
//                   ],
//                 ),
//               ),
//               Container(padding: EdgeInsets.only(left: 15, top: 15), child: Text("Request Details", style: TextStyle(color: Colors.black.withOpacity(.7), fontSize: 16, fontWeight: FontWeight.w600))),
//               Container(
//                 padding: EdgeInsets.only(left: 30, top: 10),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(right: 5),
//                           width: 10,
//                           height: 10,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Get.theme.colorScheme.secondary,
//                           ),
//                         ),
//                         Text("Total ${_addToCartController.addToCartData.length > 1 ? "Items".tr : "Item".tr} ${_addToCartController.addToCartData.length}", style: TextStyle(color: Colors.grey, fontSize: 14)),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 30, top: 5),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(right: 5),
//                           width: 10,
//                           height: 10,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Get.theme.colorScheme.secondary,
//                           ),
//                         ),
//                         Text("Amount ${_addToCartController.totalAmount().toStringAsFixed(3)} \$", style: TextStyle(color: Colors.grey, fontSize: 14))
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.only(right: 15, top: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         "cancel".tr,
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//
//   }
// }
