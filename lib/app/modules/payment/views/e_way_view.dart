import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/e_way_controller.dart';

class EWayView extends GetView<EWayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Eway Payment".tr,
          style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Column(
        children: [
          // Obx(() {
          //   return TextFormField(initialValue: Get.find<EWayController>().url.value, style: TextStyle(color: Colors.black, fontSize: 20), maxLines: 4,);
          // }),
          // Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'Service charge: \$5',
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // // Dropdown for Tips
          // DropdownButton<String>(
          //   value: controller.selectedTip.value,
          //   onChanged: (String newValue) {
          //     controller.setSelectedTip(newValue);
          //   },
          //   items: <String>['No Tip', 'Yes, add tip'].map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          // ),
          // // Textfield and Button for adding tip
          // if (controller.showAddTipField != null && controller.selectedTip.value == 'Yes, add tip')
          //   Row(
          //     children: [
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: TextField(
          //             controller: controller.tipAmountController,
          //             keyboardType: TextInputType.number,
          //             decoration: InputDecoration(
          //               hintText: 'Enter tip amount',
          //             ),
          //           ),
          //         ),
          //       ),
          //       ElevatedButton(
          //         onPressed: () {
          //           controller.addTip();
          //         },
          //         child: Text('Add Tip'),
          //       ),
          //     ],
          //   ),
          Expanded(
            child: WebView(
                initialUrl: controller.url.value,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController _con) {
                  controller.webView = _con;
                },
                onPageStarted: (String url) async {
                  print("sjdnfjknajk onPageStarted() $url");
                  controller.url.value = url;
                  controller.showConfirmationIfSuccess();
                },
                onPageFinished: (String url) {
                  print("sjdnfjknajk onPageFinished() $url");
                  controller.progress.value = 1;
                }
                ),
          ),
          Obx(() {
            if (controller.progress.value < 1) {
              return SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
                ),
              );
            } else {
              return SizedBox();
            }
          })
        ],
      ),
      // SingleChildScrollView(
      //
      //   child: WebView(
      //       initialUrl: controller.url.value,
      //       javascriptMode: JavascriptMode.unrestricted,
      //       onWebViewCreated: (WebViewController _con) {
      //         controller.webView = _con;
      //       },
      //       onPageStarted: (String url) async {
      //         print("sjdnfjknajk onPageStarted() $url");
      //         controller.url.value = url;
      //         controller.showConfirmationIfSuccess();
      //       },
      //       onPageFinished: (String url) {
      //         print("sjdnfjknajk onPageFinished() $url");
      //         controller.progress.value = 1;
      //       }),
      //   // Column(
      //   //   children: [
      //   //     Obx(() {
      //   //       return TextFormField(initialValue: Get.find<EWayController>().url.value, style: TextStyle(color: Colors.grey, fontSize: 20));
      //   //     }),
      //   //     Obx(() {
      //   //       return Expanded(
      //   //         child: WebView(
      //   //             initialUrl: controller.url.value,
      //   //             javascriptMode: JavascriptMode.unrestricted,
      //   //             onWebViewCreated: (WebViewController _con) {
      //   //               controller.webView = _con;
      //   //             },
      //   //             onPageStarted: (String url) async {
      //   //               print("sjdnfjknajk onPageStarted() $url");
      //   //               controller.url.value = url;
      //   //               controller.showConfirmationIfSuccess();
      //   //             },
      //   //             onPageFinished: (String url) {
      //   //               print("sjdnfjknajk onPageFinished() $url");
      //   //               controller.progress.value = 1;
      //   //             }),
      //   //       );
      //   //     }),
      //   //     Obx(() {
      //   //       if (controller.progress.value < 1) {
      //   //         return SizedBox(
      //   //           height: 3,
      //   //           child: LinearProgressIndicator(
      //   //             backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
      //   //           ),
      //   //         );
      //   //       } else {
      //   //         return SizedBox();
      //   //       }
      //   //     })
      //   //   ],
      //   // ),
      // ),
    );
  }
}


//  NEW
// class EWayView extends GetView<EWayController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Eway Payment".tr,
//           style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
//         ),
//       ),
//       body: ListView(
//         children: [
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Service charge: \$5',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               // Dropdown for Tips
//               DropdownButton<String>(
//                 value: controller.selectedTip.value,
//                 onChanged: (String newValue) {
//                   controller.setSelectedTip(newValue);
//                 },
//                 items: <String>['No Tip', 'Yes, add tip'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               // Textfield and Button for adding tip
//               if (controller.showAddTipField != null)
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextField(
//                           controller: controller.tipAmountController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             hintText: 'Enter tip amount',
//                           ),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         controller.addTip();
//                       },
//                       child: Text('Add Tip'),
//                     ),
//                   ],
//                 ),
//               // WebView
//               WebView(
//                 initialUrl: controller.url.value,
//                 javascriptMode: JavascriptMode.unrestricted,
//                 onWebViewCreated: (WebViewController _con) {
//                   controller.webView = _con;
//                 },
//                 onPageStarted: (String url) async {
//                   print("sjdnfjknajk onPageStarted() $url");
//                   controller.url.value = url;
//                   controller.showConfirmationIfSuccess();
//                 },
//                 onPageFinished: (String url) {
//                   print("sjdnfjknajk onPageFinished() $url");
//                   controller.progress.value = 1;
//                 },
//               ),
//             ],
//           ),
//           Obx(() {
//             if (controller.progress.value < 1) {
//               return SizedBox(
//                 height: 3,
//                 child: LinearProgressIndicator(
//                   backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
//                 ),
//               );
//             } else {
//               return SizedBox();
//             }
//           }),
//         ],
//       ),
//     );
//   }
// }
