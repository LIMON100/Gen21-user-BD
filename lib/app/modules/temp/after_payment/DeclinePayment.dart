import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/block_button_widget.dart';
import '../../home/views/home2_view.dart';
import '../../root/controllers/root_controller.dart';

class DeclinePayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child:
      // Scaffold(
      //   body: Center( // Center the content vertically and horizontally
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
      //       children:[
      //         SizedBox(height: 350),
      //         Text(
      //           "Payment Successful",
      //           style: TextStyle(fontSize: 25, color: Colors.green),
      //         ),
      //         SizedBox(height: 250),
      //         Expanded( // Take up the available vertical space
      //           child: Center( // Center the IconButton vertically
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.home,
      //                 size: 50, // Adjust the size as needed
      //                 color: Colors.orange, // Change the color to orange
      //               ),
      //               onPressed: () {
      //                 // Your onPressed logic here
      //               },
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      Scaffold(
        body: Column(
          children:[
            SizedBox(height: 350),
            Center(
              child: Text(
                "Payment Successful",
                style: TextStyle(fontSize: 25, color: Colors.green),
              ),
             ),

            SizedBox(height: 250),
            // BlockButtonWidget(
            //   text: Text(
            //     "Home".tr,
            //     style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
            //   ),
            //   color: Get.theme.colorScheme.secondary,
            //   onPressed: () {
            //     Navigator.pop(context);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => Home2View(),
            //       ),
            //     );
            //   },
            // ).marginSymmetric(vertical: 10, horizontal: 20),
            IconButton(
              icon: Icon(
                Icons.assignment_outlined,
                size: 40, // Adjust the size as needed
                color: Colors.orange, // Change the color to orange
              ),
              onPressed: () {
                // Navigator.pop(context);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => Home2View(),
                //   ),
                // );
                Get.find<RootController>().changePage(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
