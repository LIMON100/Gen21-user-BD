// /*
//  * Copyright (c) 2020 .
//  */
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart' show DateFormat;
//
// import '../../../../common/ui.dart';
// import '../../../models/booking_model.dart';
// import '../../../models/orders_model.dart';
// import '../../../routes/app_routes.dart';
//
// class OrderListItemWidget extends StatelessWidget {
//   const OrderListItemWidget({
//     Key key,
//     @required Data order,
//   })  : _order = order,
//         super(key: key);
//
//   final Data _order;
//
//   @override
//   Widget build(BuildContext context) {
//     Color _color = Get.theme.colorScheme.secondary;
//     double totalAmount = 0.00;
//     _order.customerRequest.forEach((element) {
//       totalAmount += element.orderAmmount;
//     });
//
//     double discountAmount = 5.00;
//
//     double payableAmount = totalAmount;
//
//     if (discountAmount > 0) {
//       payableAmount = totalAmount - discountAmount;
//     }
//
//     return GestureDetector(
//       onTap: () {
//         print("hsbjkakjsj orderId in build: ${_order.id}");
//         Get.toNamed(Routes.BOOKINGS, arguments: {"orderId": "${_order.id}"});
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: Ui.getBoxDecoration(),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               // height: double.maxFinite,
//
//               child: Column(
//                   children: [
//                     Text(DateFormat('HH:mm', Get.locale.toString()).format(_order.createdAt),
//                         maxLines: 1,
//                         style: Get.textTheme.bodyText2.merge(
//                           TextStyle(color: Get.theme.primaryColor, height: 1.4),
//                         ),
//                         softWrap: false,
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.fade),
//                     Text(DateFormat('dd', Get.locale.toString()).format(_order.createdAt),
//                         maxLines: 1,
//                         style: Get.textTheme.headline3.merge(
//                           TextStyle(color: Get.theme.primaryColor, height: 1),
//                         ),
//                         softWrap: false,
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.fade),
//                     Text(DateFormat('MMM', Get.locale.toString()).format(_order.createdAt),
//                         maxLines: 1,
//                         style: Get.textTheme.bodyText2.merge(
//                           TextStyle(color: Get.theme.primaryColor, height: 1),
//                         ),
//                         softWrap: false,
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.fade),
//                   ],
//                 ),
//
//               decoration: BoxDecoration(
//                 color: _color,
//                 borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//                   // alignment: WrapAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "#${_order.id}",
//                             style: Get.textTheme.bodyText2,
//                             maxLines: 3,
//                             // textAlign: TextAlign.end,
//                           ),
//                         ),
//                         // BookingOptionsPopupMenuWidget(booking: _booking),
//                       ],
//                     ),
//
//                     Divider(height: 3, thickness: 1),
//                     Container(
//                       padding: EdgeInsets.only(top: 5, bottom: 5),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Total Item: ${_order.totalAcceptItem}"),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text("Order To: ${"Dummy Name"}"),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Text("Location: ${_order.address?.address}"),
//                         ],
//                       ),
//                     ),
//                     Divider(height: 3, thickness: 1),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             "Total".tr,
//                             maxLines: 1,
//                             overflow: TextOverflow.fade,
//                             softWrap: false,
//                             style: Get.textTheme.bodyText1,
//                           ),
//                         ),
//                         Expanded(
//                             flex: 1,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 if (discountAmount > 0)
//                                   Align(
//                                     alignment: AlignmentDirectional.centerEnd,
//                                     child: Ui.getPrice(
//                                       totalAmount,
//                                       style: Get.textTheme.headline6.merge(TextStyle(
//                                         color: Colors.grey,
//                                         decoration: TextDecoration.lineThrough,
//                                       )),
//                                     ),
//                                   ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Align(
//                                   alignment: AlignmentDirectional.centerEnd,
//                                   child: Ui.getPrice(
//                                     payableAmount,
//                                     style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
