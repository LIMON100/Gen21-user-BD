/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EServiceTitleBarWidget extends StatelessWidget implements PreferredSize {
  final Widget title;
  final double additionalHeight;

  const EServiceTitleBarWidget({Key key, @required this.title, this.additionalHeight = 0.00}) : super(key: key);

  Widget buildTitleBar() {
    print("gen_log EServiceTitleBarWidget height: $additionalHeight");
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 90+additionalHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: title,
    );
  }



  @override
  Widget build(BuildContext context) {
    return buildTitleBar();
  }

  @override
  Widget get child => buildTitleBar();

  @override
  Size get preferredSize => new Size(Get.width, 110);
}
