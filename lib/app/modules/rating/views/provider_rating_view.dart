import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_new_model.dart';
import '../../../models/review_model.dart';
import '../../../services/auth_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../tips/tip_controller.dart';
import '../../tips/view/tip_view.dart';
import '../controllers/provider_rating_controller.dart';
import '../controllers/rating_controller.dart';
import '../../tips/controller/tip_controller_new.dart' as tipc;
import '../../bookings/controllers/booking_controller_new.dart' as bkc;

class ProviderRatingView extends GetView<ProviderRatingController> {

  // For tips
  final ValueNotifier<String> selectedOption = ValueNotifier<String>('NO');
  final ValueNotifier<String> tipText = ValueNotifier<String>('');
  Completer<void> _dialogCompleter = Completer<void>();

  final TipController tipController = Get.put(TipController());
  final TextEditingController textFieldController = TextEditingController();

  final ValueNotifier<bool> showButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showText = ValueNotifier<bool>(false);


  Future<void> _showTipDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Tip Amount:'),
          content: TextField(
            controller: textFieldController,
            keyboardType: TextInputType.number,
            onChanged: (String text) {
              tipController.setTipText(text);
            },
            decoration: InputDecoration(
              hintText: 'Enter tip amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _dialogCompleter.complete(); // Complete the Future when the dialog is closed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the tip amount and close the dialog
                selectedOption.value = 'YES';
                showButton.value = true;
                showText.value = true;
                Navigator.of(context).pop();
                _dialogCompleter.complete(); // Complete the Future when the dialog is closed
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      // Reset the dialogCompleter for future use
      _dialogCompleter = Completer<void>();
    });
  }
  // END TIPS part

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave a Review".tr,
          style: Get.textTheme.headline6,
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
      body: ListView(
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20),
        children: [
          Column(
            children: [
              Wrap(children: [
                Text("Hi,".tr),
                Text(
                  Get.find<AuthService>().user.value.name,
                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                ),
              ]),
              SizedBox(height: 10),
              Text(
                "How do you feel this services?".tr,
                style: Get.textTheme.bodyText2,
              ),
              Text(
                // Get.find<,
                Get.find<bkc.BookingControllerNew>().booking.value.id,
                style: Get.textTheme.bodyText2,
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: Get.width,
              decoration: Ui.getBoxDecoration(),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  //   child: CachedNetworkImage(
                  //     height: 160,
                  //     width: double.infinity,
                  //     fit: BoxFit.cover,
                  //     // imageUrl: controller.booking.value.eService.firstImageUrl,
                  //     placeholder: (context, url) => Image.asset(
                  //       'assets/img/loading.gif',
                  //       fit: BoxFit.cover,
                  //       width: double.infinity,
                  //       height: 160,
                  //     ),
                  //     errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  // Text(
                  //   // controller.booking.value.eService.name,
                  //   "Test",
                  //   style: Get.textTheme.headline6,
                  //   textAlign: TextAlign.center,
                  // ),

                  SizedBox(height: 20),
                  Text(
                    "Click on the stars to rate this service".tr,
                    style: Get.textTheme.caption,
                  ),
                  SizedBox(height: 6),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return InkWell(
                          onTap: () {
                            controller.review.update((val) {
                              val.rate = (index + 1).toDouble();
                            });
                          },
                          child: index < controller.review.value.rate
                              ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                              : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
                        );
                      }),
                    );
                  }),
                  SizedBox(height: 30)
                ],
              ),
              // Obx(
              //   () =>
              //       Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ClipRRect(
              //         borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              //         child: CachedNetworkImage(
              //           height: 160,
              //           width: double.infinity,
              //           fit: BoxFit.cover,
              //           // imageUrl: controller.booking.value.eService.firstImageUrl,
              //           placeholder: (context, url) => Image.asset(
              //             'assets/img/loading.gif',
              //             fit: BoxFit.cover,
              //             width: double.infinity,
              //             height: 160,
              //           ),
              //           errorWidget: (context, url, error) => Icon(Icons.error_outline),
              //         ),
              //       ),
              //       SizedBox(height: 20),
              //       Text(
              //         // controller.booking.value.eService.name,
              //         "Test",
              //         style: Get.textTheme.headline6,
              //         textAlign: TextAlign.center,
              //       ),
              //       SizedBox(height: 20),
              //       Text(
              //         "Click on the stars to rate this service".tr,
              //         style: Get.textTheme.caption,
              //       ),
              //       SizedBox(height: 6),
              //       Obx(() {
              //         return Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: List.generate(5, (index) {
              //             return InkWell(
              //               onTap: () {
              //                 controller.review.update((val) {
              //                   val.rate = (index + 1).toDouble();
              //                 });
              //               },
              //               child: index < controller.review.value.rate
              //                   ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
              //                   : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
              //             );
              //           }),
              //         );
              //       }),
              //       SizedBox(height: 30)
              //     ],
              //   ),
              // )
          ),
          TextFieldWidget(
            labelText: "Write your review".tr,
            hintText: "Tell us somethings about this service".tr,
            iconData: Icons.description_outlined,
            onChanged: (text) {
              controller.review.update((val) {
                val.review = text;
              });
            },
          ),

          // DropDown Menu
          SizedBox(height: 10),
          Center(
            child: Text(
              "TIPS".tr,
              style: Get.textTheme.headline6,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "TIP".tr,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.bodyText2,
                    ),
                    SizedBox(width: 20),
                    DropdownButton<String>(
                      value: selectedOption.value,
                      onChanged: (String value) async {
                        if (value == 'YES') {
                          await _showTipDialog(context);
                          await _dialogCompleter.future; // Wait for the dialog to complete
                        } else {
                          selectedOption.value = value;
                        }
                      },
                      items: ['YES', 'NO'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // TextField(
          //   controller: textFieldController,
          //   keyboardType: TextInputType.number,
          //   onChanged: (String text) {
          //     tipController.setTipText(text);
          //   },
          //   decoration: InputDecoration(
          //     hintText: 'Enter amount',
          //     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 100), // Adjust padding as needed
          //     // Use alignLabelWithHint to align the hint text with the entered text
          //     alignLabelWithHint: true,
          //     // Align the entered text to the center
          //     // hintStyle: TextStyle(textBaseline: ),
          //   ),
          //   style: TextStyle(
          //     fontSize: 16, // Adjust font size as needed
          //     // Additional style properties if needed
          //   ),
          // ),
          SizedBox(height: 10),
          ValueListenableBuilder<bool>(
            valueListenable: showText,
            builder: (context, value, child) {
              if(value){
                return SizedBox(
                  height: 48,
                  child: TextField(
                    controller: textFieldController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter tip amount',
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                    ],
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                    onChanged: (String text) {
                      // Your onChanged logic here
                    },
                  ),
                );
              }
              else {
                return Container(); // Empty container when button is not visible
              }
            }
          ),

          SizedBox(width: 20),
          ValueListenableBuilder<bool>(
            valueListenable: showButton,
            builder: (context, value, child) {
              if (value) {
                return BlockButtonWidget(
                  text: Text(
                    "Pay Tips & Submit Review".tr,
                    style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () async {
                    String inputText = textFieldController.text;
                    int inputValue = int.parse(inputText);

                    // if(inputValue > 0 && reviewCheck.rate.toString().isNotEmpty && reviewCheck.review.toString().isNotEmpty) {
                    final bool checkgivenReview = await controller.addTipsProviderReview();

                    if(inputValue > 0 && checkgivenReview) {
                      Get.to(TipsView());
                    }
                    else{
                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Total payable amount can't be 0!".tr));
                    }
                  },
                ).marginSymmetric(vertical: 10, horizontal: 20);
              } else {
                // return Container(); // Empty container when button is not visible
                return BlockButtonWidget(
                  text: Text(
                    "Submit Review".tr,
                    style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () {
                    controller.addProviderReview();
                  },
                ).marginSymmetric(vertical: 10, horizontal: 20);
              }
            },
          ),
        ],
      ),
    );
  }
}
